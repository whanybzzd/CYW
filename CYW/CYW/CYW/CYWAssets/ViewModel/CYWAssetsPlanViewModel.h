//
//  CYWAssetsPlanViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsPlanViewModel : BaseViewModel
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSMutableArray *datassetslArray;
@property (nonatomic, assign) NSInteger refreshIndex;
@property (nonatomic) RACCommand *refresPlanCommand; /**< 请求 */
@property (nonatomic, assign) NSInteger index;
@end
