//
//  CYWAssetsRecordViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsRecordViewModel : BaseViewModel
@property (nonatomic) RACCommand *refresRecordCommand;
@property (nonatomic, assign) NSInteger refreshType;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic, retain) NSMutableArray *monthArray;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic) RACCommand *refresSearchCommand;
@property (nonatomic, retain) id object;

@end
