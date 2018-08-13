//
//  AFNManagerTool.h
//  xbm
//
//  Created by iMac on 2017/5/9.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^RequestSuccessed)(id responseObject);
typedef void (^RequestFailure)(NSInteger errorCode, NSString *errorMessage);

@interface AFNManagerTool : AFHTTPSessionManager

@property (nonatomic,copy) NSString * deviceId;//设备编号
@property (nonatomic,copy) NSString * requestId;//请求编号
@property (nonatomic,copy) NSString * method;//请求方式
@property (nonatomic,copy) NSString * value;//请求值（3des加密）
@property (nonatomic,copy) NSString * remark;//备注
@property (nonatomic,copy) NSString * sign;//MD5(deviceId,requestId,method,value)
@property long time;//请求事件

+ (instancetype)sharedInstance;


/**
 所有公共请求方法

 @param url 请求路径
 @param apiName 追加的地址(根据项目需求来)
 @param dictParam 传入的参数
 @param datas 图片数组
 @param isModel 是否需要Model画
 @param sign sign
 @param requestType 请求类型
 @param requestSuccess 请求成功
 @param requestFailer 请求失败
 */
- (void)requestByToUrl:(NSString *)url
               withAPi:(NSString *)apiName
         withDictParam:(NSDictionary *)dictParam
             withDatas:(NSArray *)datas
               isModel:(BOOL)isModel
                isSign:(BOOL)sign
        withRequesType:(RequestType)requestType
      requestSuccessed:(RequestSuccessed)requestSuccess
         requestFailer:(RequestFailure)requestFailer;


/**
 取消网络请求
 */
- (void)cancelAllOperations;
@end
