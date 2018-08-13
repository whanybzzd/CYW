//
//  BaseViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/11.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray array];
        self.curpageIndex=1;
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [[self refreshNewData] takeUntil:self.rac_willDeallocSignal];
        }];
    }
    return self;
}
@end
