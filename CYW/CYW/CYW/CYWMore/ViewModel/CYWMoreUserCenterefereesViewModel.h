//
//  CYWMoreUserCenterefereesViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWMoreUserCenterefereesViewModel : BaseViewModel
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic) RACCommand *refreshrefereesCommand;//上传头像
@end
