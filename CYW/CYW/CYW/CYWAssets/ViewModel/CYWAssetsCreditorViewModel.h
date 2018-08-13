//
//  CYWAssetsCreditorViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsCreditorViewModel : BaseViewModel


/**
 债权转让

 @param investId 标号Id
 @param trans nil
 @param perium nil
 @param action 类型
 @return 信号量
 */
- (RACSignal *)transfer:(NSString *)investId extensionId:(NSString *)extensionId trans:(NSString *)trans perium:(NSString *)perium action:(NSString *)action;


/**
 刷新数据和加载更多

 @param type 类型
 @param page 页数
 @return 信号量
 */
- (RACSignal *)refreshNormal:(NSString *)type curpage:(NSInteger)page;


/**
 计算展期、转让费用

 @param inverstId id
 @return 信号量
 */
- (RACSignal *)refreshInverstId:(NSString *)inverstId;


/**
 取消转让

 @param inverstId id
 @return 信号量
 */
- (RACSignal *)cancelTransfer:(NSString *)inverstId;
@end
