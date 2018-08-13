//
//  AFNManagerTool.m
//  xbm
//
//  Created by iMac on 2017/5/9.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "AFNManagerTool.h"
#import <YRJSONAdapter/YRJSONAdapter.h>
#import "AppDelegate.h"
@interface AFNManagerTool()

@property (nonatomic, retain) AFHTTPSessionManager *manager;

@end
@implementation AFNManagerTool


+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (instancetype)init{

    if (self=[super init]) {

        self.manager=[AFHTTPSessionManager manager];
        self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.manager.requestSerializer.timeoutInterval = 30.0f;//设置POST和GET的超时时间
        //[self.manager.requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"content-type"];
        [self.manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"text/plain", nil]];
        // 设置安全策略
        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    }

    return self;
}

- (void)cancelAllOperations{

    [self.manager.operationQueue cancelAllOperations];
    
}
- (void)requestByToUrl:(NSString *)url
               withAPi:(NSString *)apiName
         withDictParam:(NSDictionary *)dictParam
             withDatas:(NSArray *)datas
               isModel:(BOOL)isModel
                isSign:(BOOL)sign
        withRequesType:(RequestType)requestType
      requestSuccessed:(RequestSuccessed)requestSuccess
         requestFailer:(RequestFailure)requestFailer{




    //1. url合法性判断
    if (![NSString isUrl:url]) {
        requestFailer(1005, [NSString stringWithFormat:@"传递的url[%@]不合法！", url]);
        return;
    }
    //2. apiName简单判断
    apiName = [NSString trimString:apiName];//([apiName hasPrefix:@"/"] ? [apiName substringFromIndex:1] : apiName)

    //3. 组装完整的url地址
    //NSString *urlString = [url stringByAppendingFormat:@"%@%@",
    //                       ([url hasSuffix:@"/"] ? @"" : @"/"),
    //                       ([apiName hasPrefix:@"/"] ? [apiName substringFromIndex:1] : apiName)
     //                      ];

    NSMutableString *newUrlString = [NSMutableString stringWithString:url];
    NSDictionary *signature = [self signatureWithParam:dictParam withRequestApi:apiName];
    //NSLog(@"signature:%@",signature);
    NSMutableDictionary *newDictParam = [NSMutableDictionary dictionaryWithDictionary:signature];
    if ([NSObject isNotEmpty:signature]) {
        
        [newDictParam setObject:@"ios" forKey:@"platform"];
        [newDictParam setObject:VersionNumber forKey:@"versionCode"];
    }

    //NSLog(@"字典：%@",dictParam);

    //NSLog(@"newDIct:%@==url:%@",newDictParam,url);


    void (^requestSuccessed2)(NSURLSessionDataTask *sessionDataTask,id responseObject)=^(NSURLSessionDataTask *sessionDataTask,id responseObject){

        //NSLog(@"我曹:%@",responseObject);

        if (!isModel) {
            requestSuccess(responseObject);
            return ;
        }
        JSONModelError *initError;
        BaseModel *baseModel=nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            baseModel=[[BaseModel alloc] initWithDictionary:responseObject error:&initError];
        }
        else if ([responseObject isKindOfClass:[NSString class]]){
            
            baseModel=[[BaseModel alloc] initWithString:responseObject error:&initError];
        }
        
        if ([NSObject isNotEmpty:baseModel]) {
            
            requestSuccess(baseModel);
        }

        else{

            if (initError) {

                requestFailer(1001,initError.localizedDescription);
            }
            else{

                requestFailer(1002,@"本地对象映射出错");
            }
        }


    };

    //   定义返回失败的block
    void (^requestFailure2)(NSURLSessionDataTask *sessionDataTask, id responseObject) = ^(NSURLSessionDataTask *sessionDataTask, NSError *error) {
        
        NSHTTPURLResponse *status=   (NSHTTPURLResponse *)sessionDataTask.response;
        if (200 != status.statusCode) {
            if (401 == status.statusCode) {
                requestFailer(1003, @"您还未登录呢！");
//                [[Login sharedInstance] clearLoginData];
//                NSString *swithch=[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
//                if ([NSString isNotEmpty:swithch]&&1==[swithch integerValue]) {
//
//                    [((AppDelegate *)[UIApplication sharedApplication].delegate) setUpGueTabbarController];
//
//                }else{
//
//                    [((AppDelegate *)[UIApplication sharedApplication].delegate) setUpTabbarController];
//                }
            }
            else {
                requestFailer(1004, @"请求错误！");
            }
        }
        else {
            requestFailer(status.statusCode, error.localizedDescription);
        }

    };

    if (RequestTypeGET == requestType) {
        NSLog(@"getting data...");
        [self.manager GET:newUrlString
               parameters:newDictParam
                 progress:nil
                  success:requestSuccessed2
                  failure:requestFailure2];


    }
    else if (RequestTypePOST == requestType) {
        NSLog(@"posting data...");
        [self.manager POST:newUrlString
                parameters:newDictParam
                  progress:nil
                   success:requestSuccessed2
                   failure:requestFailure2];


    }else if (RequestTypeUploadFile == requestType) {
        NSLog(@"uploading data...");
        [self.manager  POST:newUrlString
                 parameters:newDictParam
  constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {

      NSInteger imgCount = 1;

      for (NSData *imageData in datas) {

          //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

          //formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
          NSString *filename= [NSString stringWithFormat:@"%zd%@.png",imgCount,@(imgCount)];

          [formData appendPartWithFileData:imageData name:filename fileName:filename mimeType:@"image/png"];

          imgCount++;

      }


  }success:requestSuccessed2 failure:requestFailure2];

    }else if (RequestTypePostBodyData==requestType){
        NSLog(@"posting bodydata...");


    }
    else if (RequestTypePostDownLoad==requestType){

        [self.manager POST:newUrlString parameters:newDictParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

            //视频上传
            for (NSData *videoData in datas) {

                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";

                NSString *fileName = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];

                [formData appendPartWithFileData:videoData
                                            name:[NSString stringWithFormat:@"uploadFile%@",fileName]
                                        fileName:[NSString stringWithFormat:@"%@.mp4",fileName]
                                        mimeType:@"video/quicktime"];
            }

        } success:requestSuccessed2 failure:requestFailure2];
    }


}


/**
 对参数进行签名

 @param param 对参数加密
 @param api 接口名称
 @return signature
 */
- (NSDictionary *)signatureWithParam:(NSDictionary *)param withRequestApi:(NSString *)api{
    
    //设置手机编号
    self.deviceId = [NSString currentDeviceNumber];
    //设置请求号
    NSString * requestIDString = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"requestID"]!=nil) {
        requestIDString = [[NSUserDefaults standardUserDefaults] objectForKey:@"requestID"];
    }else{
        long tag = 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"requestID"];
    }
    long tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"requestID"] integerValue];
    self.requestId = [NSString stringWithFormat:@"%ld",tag];
    tag++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"requestID"];
    //设置请求方法
    self.method = api;
    //设置value
    self.value = [NSString TripleDES: [param JSONString] encryptOrDecrypt:kCCEncrypt key:K3DESKey];
    //设置备注
    self.remark = @"";
    //设置MD5（deviceId,requestId,method,value）
    NSString * signString = [NSString stringWithFormat:@"%@%@%@%@",self.deviceId,self.requestId,self.method,self.value];
    self.sign = [[signString MD5Hash] lowercaseString];
    //设置事件
    self.time = 0;
    
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.deviceId,@"deviceId",
                          self.requestId,@"requestId",
                          self.method,@"method",
                          self.value,@"value",
                          self.remark,@"remark",
                          self.sign,@"sign",
                          self.time,@"time", nil];
    return dic;
    
    
}

@end
