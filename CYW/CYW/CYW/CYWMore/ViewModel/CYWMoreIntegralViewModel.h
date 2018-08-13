//
//  CYWMoreIntegralViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWMoreIntegralViewModel : BaseViewModel
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic) RACCommand *refreshIntegralCommand;//上传头像
@end
