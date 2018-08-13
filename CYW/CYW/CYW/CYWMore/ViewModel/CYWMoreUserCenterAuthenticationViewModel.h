//
//  CYWMoreUserCenterAuthenticationViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWMoreUserCenterAuthenticationViewModel : BaseViewModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *idCar;
@property (nonatomic) RACCommand *refreshAuthenticationCommand;//上传头像

@property (nonatomic) RACCommand *refreshRealCommand;//查询是否已经实名认证成功
@end
