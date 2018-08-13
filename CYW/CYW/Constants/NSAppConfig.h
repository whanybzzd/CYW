//
//  NSAppConfig.h
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAppConfig : NSObject
/**首页BannerCell标识*/
UIKIT_EXTERN NSString * const HomeBannerItemCell;

/**首页专区Cell标识*/
UIKIT_EXTERN NSString * const HomeZoneItemCell;

/**首页新手Cell标识*/
UIKIT_EXTERN NSString * const HomeNewStandItemCell;

/**首页新手列表标识*/
UIKIT_EXTERN NSString * const HomeItemCell;

/**指导页控制当前版本*/
UIKIT_EXTERN NSString * const kGuideNormalVersion;

/**返回按钮样式*/
UIKIT_EXTERN NSString * const kParamBackType;

/**正则表达式*/
UIKIT_EXTERN NSString * const RegexUrl;

/**UITabelViewCell Item*/
UIKIT_EXTERN NSString * const kCellIdentifier;

/**UICollectionView Item*/
UIKIT_EXTERN NSString * const kItemCellIdentifier;

/**AppStore下载地址*/
UIKIT_EXTERN NSString * const APP_StoreUrl;

/**加密钥匙串*/
UIKIT_EXTERN NSString * const K3DESKey;

/**动画时间*/
UIKIT_EXTERN const CGFloat DefaultAnimationDuration;

/**动画时间2*/
UIKIT_EXTERN const CGFloat kDefaultAnimationDuration02;

/**tag*/
UIKIT_EXTERN const CGFloat kResPathNoramlScore;

/**视频地址*/
UIKIT_EXTERN NSString * const VIDEO_URL;

@end
