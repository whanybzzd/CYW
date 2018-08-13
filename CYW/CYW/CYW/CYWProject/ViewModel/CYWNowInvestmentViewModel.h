//
//  CYWNowInvestmentViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/31.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWNowInvestmentViewModel : NSObject
@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic, retain) NSMutableArray *investsArray;

@property (nonatomic) RACCommand *refreshNowInvestCommand;

@property (nonatomic, retain) NSString *loadRequestType;
@property (nonatomic, copy) NSString *money;
@property (nonatomic) RACCommand *refreshinvestCommand;//投资


@property (nonatomic) RACCommand *refreshTransferRepayCommand;
@end
