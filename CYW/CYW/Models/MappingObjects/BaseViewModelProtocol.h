//
//  BaseViewModelProtocol.h
//  CYW
//
//  Created by jktz on 2017/10/11.
//  Copyright © 2017年 jktz. All rights reserved.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import <Foundation/Foundation.h>

@protocol BaseViewModelProtocol <NSObject>

@optional
- (RACSignal *)refreshNewData;//正常刷新
- (RACSignal *)refreshMoreNewData;//刷新更多
@end
