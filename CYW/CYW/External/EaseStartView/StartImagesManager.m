//
//  StartImagesManager.m
//  CYW
//
//  Created by jktz on 2017/12/8.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "StartImagesManager.h"
#import <AFNetworking/AFNetworking.h>
@interface StartImagesManager()



@end
@implementation StartImagesManager
+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (instancetype)init{
    if (self=[super init]) {
        [self timeCookie];
        [self createFolder:[self downloadPath]];
    }
    return self;
}


- (BOOL)createFolder:(NSString *)path{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)){
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        isCreated = YES;
    }
    if (isCreated) {
        [NSURL addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path isDirectory:YES]];
    }
    return isCreated;
}

- (NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"CYW_StartImages"];
    return downloadPath;
}

- (void)managerFile:(StartManagerFile)file{
    
    self.files =file;
    [AFNManager postDataWithAPI:@"api/wallpaper/wallpapers"
                  withDictParam:nil
                  withModelName:@""
                        isModel:NO
               requestSuccessed:^(id responseObject) {
                   
                   NSLog(@"图片responseObject：%@",responseObject);
                   
                   //[[StorageManager sharedInstance] setUserConfigValue:responseObject forKey:@""];//存储
                   
                   //[[StorageManager sharedInstance] userConfigValueForKey:@""];//读取
                   //
                   
                   self.files([self imageFile:@"22"]);
                   [self startDownloadImage];//请求下载图片
                   
               } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                   
                   self.files([self imageFile:@"11"]);
               }];
}



- (void)startDownloadImage{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
                [self downloadUrl:nil];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"无线网络");
                break;
            }
            default:
                break;
        }
    }];
    
    // 3.start monitoring
    [mgr startMonitoring];
    
}

- (void)downloadUrl:(NSString *)url{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //不同的设备下载不同尺寸的图片
    NSURL *URL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527075333120&di=6d87f643cfbd6c3d019e137dc90e4270&imgtype=0&src=http%3A%2F%2Fscimg.jb51.net%2Fallimg%2F150516%2F14-1505161S434B9.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *pathDisk = [[documentPath stringByAppendingPathComponent:@"CYW_StartImages"] stringByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:pathDisk];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"downloaded file_path is to: %@", filePath);
    }];
    [downloadTask resume];
}

- (UIImage *)imageFile:(NSString *)name{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *f= [[documentPath stringByAppendingPathComponent:@"CYW_StartImages"]
                  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
   return [UIImage imageWithContentsOfFile:f];
}

- (void)timeCookie{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    if ([NSString isEmpty:[[NSUserDefaults standardUserDefaults]objectForKey:@"currentDateString"]]) {
        
        [[NSUserDefaults standardUserDefaults] setValue:currentDateString forKey:@"currentDateString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSInteger str=[NSString dateTimeDifferenceWithStartTime:[[NSUserDefaults standardUserDefaults]objectForKey:@"currentDateString"] endTime:currentDateString];
    if (str>3) {
        
        //清空本地保存图片
        
        NSString *docsDir = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"CYW_StartImages"]];
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:docsDir error:nil];
        
        //重新保存时间
        [[NSUserDefaults standardUserDefaults] setValue:currentDateString forKey:@"currentDateString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end


