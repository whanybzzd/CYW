//
//  CYWAssetsBorrowedViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsBorrowedViewModel : BaseViewModel
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic, assign) NSInteger refreshType;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) RACCommand *refresBorrowedCommand;
@property (nonatomic, copy) NSString *refreshDataType;
@property (nonatomic, retain) id object;
@end
