//
//  BaseViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/11.
//  Copyright © 2017年 jktz. All rights reserved.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import <Foundation/Foundation.h>
#import "BaseViewModelProtocol.h"
@interface BaseViewModel : NSObject<BaseViewModelProtocol>
@property (nonatomic) NSArray *dataSource;
@property (nonatomic, assign) NSInteger curpageIndex;
@property (nonatomic) RACCommand *refreshDataCommand; /**< 请求 */
@end
