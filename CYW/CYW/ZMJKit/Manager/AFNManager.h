//
//  AFNManager.h
//  Framework
//
//  Created by ZMJ on 16/2/5.
//  Copyright © 2016年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - block定义
typedef void (^RequestSuccessed)(id responseObject);
typedef void (^RequestFailure)(NSInteger errorCode, NSString *errorMessage);

@interface AFNManager : NSObject


/**
 *  常规的get数据请求
 *
 *  @param apiName        请求API地址
 *  @param dictParam      请求参数
 *  @param modelName      需要映射的Model名称
 *  @param isModel        是否需要映射
 *  @param requestSuccess requestSuccess
 *  @param requestFailer  requestFailer
 */
+ (void)getDataWithAPI:(NSString *)apiName
         withDictParam:(NSDictionary *)dictParam
         withModelName:(NSString *)modelName
               isModel:(BOOL)isModel
      requestSuccessed:(RequestSuccessed) requestSuccess
         requestFailer:(RequestFailure) requestFailer;



/**
 *  常规的post数据请求
 *
 *  @param apiName        请求API地址
 *  @param dictParam      请求参数
 *  @param modelName      需要映射的Model名称
 *  @param isModel        是否需要映射
 *  @param requestSuccess requestSuccess
 *  @param requestFailer  requestFailer
 */
+ (void)postDataWithAPI:(NSString *)apiName
          withDictParam:(NSDictionary *)dictParam
          withModelName:(NSString *)modelName
                isModel:(BOOL)isModel
       requestSuccessed:(RequestSuccessed) requestSuccess
          requestFailer:(RequestFailure) requestFailer;



/**
 *  自定义的get请求
 *
 *  @param url            自定义地址
 *  @param apiName        自定义的API地址
 *  @param dictParam      请求参数
 *  @param modelName      需要映射的Model名称
 *  @param isModel        是否需要映射
 *  @param requestSuccess requestSuccess
 *  @param requestFailer  requestFailer
 */

+ (void)getDataFromURL:(NSString *)url
               withApi:(NSString *)apiName
         withDictParam:(NSDictionary *)dictParam
         withModelName:(NSString *)modelName
               isModel:(BOOL)isModel
      requestSuccessed:(RequestSuccessed) requestSuccess
         requestFailer:(RequestFailure) requestFailer;



/**
 *  自定义的post请求
 *
 *  @param url            自定义地址
 *  @param apiName        自定义的API地址
 *  @param dictParam      请求参数
 *  @param modelName      需要映射的Model名称
 *  @param isModel        是否需要映射
 *  @param requestSuccess requestSuccess
 *  @param requestFailer  requestFailer
 */

+ (void)postDataFromURL:(NSString *)url
                withApi:(NSString *)apiName
          withDictParam:(NSDictionary *)dictParam
          withModelName:(NSString *)modelName
                isModel:(BOOL)isModel
       requestSuccessed:(RequestSuccessed) requestSuccess
          requestFailer:(RequestFailure) requestFailer;






/**
 *  图片上传（文件方式上传）
 *
 *  @param url              为空没有任何影响
 *  @param imageDatas       图片地址数组
 *  @param apiName          请求API地址
 *  @param dictParam        请求参数
 *  @param modelName        需要映射的Model名称
 *  @param isModel          是否需要映射
 *  @param sign             是否需要加密
 *  @param requestSuccessed requestSuccessed
 *  @param requestFailure   requestFailure
 */
+ (void)uploadImage:(NSString *)url
     withImageDatas:(NSArray *)imageDatas
            withApi:(NSString *)apiName
       andDictParam:(NSDictionary *)dictParam
          dataModel:(NSString *)modelName
            isModel:(BOOL)isModel
         isSign:(BOOL)sign
   requestSuccessed:(RequestSuccessed)requestSuccessed
     requestFailure:(RequestFailure)requestFailure;




/**
 *  视频上传
 *
 *  @param videoDatas       视频data（后期有可能要改变）
 *  @param apiName          请求API地址
 *  @param dictParam        请求参数
 *  @param modelName        需要映射的Model名称
 *  @param isModel          是否需要映射
 *  @param sign             是否需要加密
 *  @param requestSuccessed requestSuccessed
 *  @param requestFailure   requestFailure
 */
+ (void)uploadWithDataVideos:(NSArray *)videoDatas
           withApi:(NSString *)apiName
      andDictParam:(NSDictionary *)dictParam
         dataModel:(NSString *)modelName
           isModel:(BOOL)isModel
            isSign:(BOOL)sign
  requestSuccessed:(RequestSuccessed)requestSuccessed
    requestFailure:(RequestFailure)requestFailure;



/**
 取消网络请求
 */
+ (void)cancelAllOperations;
@end
