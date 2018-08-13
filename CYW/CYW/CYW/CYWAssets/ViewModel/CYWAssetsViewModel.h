//
//  CYWAssetsViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsViewModel : BaseViewModel
@property (nonatomic, assign) NSInteger refreshIndex;
@property (nonatomic, retain) NSString *refreshType;
@property (nonatomic, retain) NSMutableArray *datassetslArray;
@property (nonatomic, retain) NSString *loadId;



@property (nonatomic) RACCommand *refreshEnvelopeCommand;



//TODO:这里是处理第一次使用RAC的时候逻辑错误的问题，之前的代码不擅长


/**
 请求数据

 @param type 刷新的类型
 @return 信号量
 */
- (RACSignal *)loadRefreshDataType:(RefreshType)type;
@end
