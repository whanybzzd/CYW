//
//  CYWAssetsInvestViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsInvestViewModel : BaseViewModel
@property (nonatomic, retain) NSMutableArray *datassetslArray;
@property (nonatomic, retain) NSMutableArray *stateArray;
@property (nonatomic, assign) NSInteger refreshIndex;
@property (nonatomic, retain) NSString *investId;
@property (nonatomic) RACCommand *refresInvestCommand; /**< 请求 */
@property (nonatomic) RACCommand *refresStateCommand; /**< 请求 */


//我的借款还款计划
@property (nonatomic) RACCommand *refresBorrowedCommand; /**< 请求  repayments*/
@property (nonatomic, retain) NSMutableArray *borrowedDataArray;
@property (nonatomic, retain) NSString *borrowId;


@property (nonatomic) RACCommand *refresRepaymentsCommand;
@end
