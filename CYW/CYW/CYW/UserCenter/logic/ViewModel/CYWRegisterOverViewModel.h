//
//  CYWRegisterOverViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWRegisterOverViewModel : NSObject

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *agaginpassword;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, retain) RACCommand *submitCommand;
@end
