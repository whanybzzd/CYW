//
//  BaseModel.h
//  xcode6
//
//  Created by ZMJ on 15/3/21.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//
#import <JSONModel/JSONModel.h>
//#import "JSONModel.h"

@interface BaseModel : JSONModel
@property (copy, nonatomic) NSString *deviceId;
@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *requestId;
@property (retain, nonatomic) NSObject<ConvertOnDemand> *result;
@property (copy, nonatomic) NSString *resultCode;
@property (copy, nonatomic) NSString *resultMsg;
@property (copy, nonatomic) NSString *sign;
@property (copy, nonatomic) NSString *time;
@end

/**
 *  公共model的基类，主要是设置所有参数都是optional的，并添加序列化和反序列化方法
 */

@interface BaseDataModel : JSONModel

@end
