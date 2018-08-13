//
//  CYWCalculatorViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWCalculatorViewModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;


@property (nonatomic, copy) NSString *cal;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *ann;

@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic) RACCommand *refreshcomputationsCommand;
@end
