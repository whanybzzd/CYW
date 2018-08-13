//
//  CYWAssetsCalendarViewModel.h
//  CYW
//
//  Created by jktz on 2017/11/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWAssetsCalendarViewModel : NSObject
@property (nonatomic) RACCommand *refreshCalendarCommand;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSMutableArray *monthlArray;
@property (nonatomic) RACCommand *refreshCalendarMonthCommand;

@property (nonatomic, retain) NSMutableArray *moneyArray;
@end
