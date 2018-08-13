//
//  CYWForgetViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWForgetViewModel : NSObject
@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, retain) RACCommand *forgetCommand;
@property (nonatomic, retain) RACCommand *nextCommand;


@property (nonatomic, copy) NSString  *newpassword;
@property (nonatomic, copy) NSString *againpassword;

@property (nonatomic, retain) RACCommand *submitCommand;
@end
