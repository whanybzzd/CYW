//
//  CYWMoreGestureViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWMoreGestureViewModel : BaseViewModel
@property (nonatomic) RACCommand *refreshUnlockCommand;
@property (nonatomic, copy) NSString *password;

@property (nonatomic) RACCommand *refreshUnlockloginCommand;

@property (nonatomic) RACCommand *refreshforgetCommand;

//验证手势密码
@property (nonatomic) RACCommand *refreshvalidationCommand;
@end
