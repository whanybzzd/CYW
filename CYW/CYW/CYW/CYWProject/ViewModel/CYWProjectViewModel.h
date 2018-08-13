//
//  CYWProjectViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWProjectViewModel : BaseViewModel

@property (nonatomic, assign) NSInteger refreshIndex;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) RACCommand *refresProjectCommand; /**< 请求 */
@property (nonatomic) RACCommand *refreshCreditorsCommand;

@end
