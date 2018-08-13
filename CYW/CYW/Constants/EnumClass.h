//
//  EnumClass.h
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#ifndef GeneralFramework_EnumClass_h
#define GeneralFramework_EnumClass_h

typedef NS_ENUM(NSInteger, GenderType) {
    GenderTypeNotSet = 0,
    GenderTypeMale,
    GenderTypeFeMale
};


typedef NS_ENUM (NSInteger, RequestType) {
    RequestTypeGET = 0,
    RequestTypePOST,
    RequestTypeUploadFile,
    RequestTypePostBodyData,
    RequestTypePostDownLoad
};

/*  图片质量
 *  高质量：原图
 *  中等质量：原图大小的70%。最小宽度：480 最大宽度：720
 *  低质量：原图大小的50%。最小宽度：320 最大宽度：480
 */
typedef NS_ENUM(NSUInteger, ImageQuality) {
    ImageQualityLow = 0,        //低质量图片
    ImageQualityNormal = 1,     //中等质量图片
    ImageQualityHigh = 2,       //高质量图片
    ImageQualityAuto = 10       //根据网络自动选择图片质量
};

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeWeiboSina = 0,
    ShareTypeWeiboTencent,
    ShareTypeWechatSession,     //微信好友
    ShareTypeWechatTimeline,    //微信朋友圈
    ShareTypeWechatFavorite,    //微信收藏
    ShareTypeMobileQQ,          //手机qq
    ShareTypeAbbKbb
};

typedef NS_ENUM(NSUInteger, BackType) {
    BackTypeBack = 0,
    BackTypeSliding,
    BackTypeDismiss
};
typedef NS_ENUM(NSUInteger, VersionCompareResult) {
    VersionCompareResultAscending = 0,//版本小
    VersionCompareResultSame,//版本一样
    VersionCompareResultDescending,//版本大
};

typedef NS_ENUM(NSUInteger,CellType) {
    
    CellHome=0,
    CellProject,
};
typedef NS_ENUM(NSInteger, RefreshType) {
    Refreshload = 0,
    RefreshloadMore
};
#endif
