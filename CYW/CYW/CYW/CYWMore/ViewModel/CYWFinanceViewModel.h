//
//  CYWFinanceViewModel.h
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWFinanceViewModel : NSObject
@property (nonatomic, assign) NSInteger typeIdnex;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic) RACCommand *refreshFinanceCommand;
@property (nonatomic) RACCommand *refreshCenterCommand;

@end
