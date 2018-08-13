//
//  ColorClass.h
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#ifndef GeneralFramework_ColorClass_h
#define GeneralFramework_ColorClass_h
/**
 *  颜色
 */
#define RGB(r, g, b)                    [UIColor colorWithRed:r green:g blue:b alpha:1.0f]
#define kDefaultEmptyTextColor          RGB(122, 122, 122)      //列表为空时的提醒文字颜色
#define kDefaultViewColor               RGB(236, 236, 236)      //self.view的默认背景颜色


#define kColorNavBG [UIColor colorWithHexString:@"0xF8F8F8"]
#define kColorCCC [UIColor colorWithHexString:@"0xCCCCCC"]
#define kColorBrandGreen [UIColor colorWithHexString:@"0x3BBD79"]

#endif
