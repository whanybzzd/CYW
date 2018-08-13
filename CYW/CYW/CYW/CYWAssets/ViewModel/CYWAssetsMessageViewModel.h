//
//  CYWAssetsMessageViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsMessageViewModel : BaseViewModel
@property (nonatomic) RACCommand *refreshMessageCommand;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@end
