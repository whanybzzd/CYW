//
//  CYWLoginViewModel.h
//  CYW
//
//  Created by jktz on 2017/9/28.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWLoginViewModel : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) RACCommand *loginCommand;
@property (nonatomic, retain) RACCommand *loginUserCommand;

@property (nonatomic, retain) RACCommand *guestCommand;
@end
