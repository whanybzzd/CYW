//
//  CYWMoreUserCenterViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"
@interface CYWMoreUserCenterViewModel : BaseViewModel
@property (nonatomic, retain) NSString *photo;
@property (nonatomic) RACCommand *refreshCenterAvaterCommand;//上传头像
@end
