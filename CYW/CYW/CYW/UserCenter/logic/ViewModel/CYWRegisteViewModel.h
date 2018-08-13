//
//  CYWRegisteViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWRegisteViewModel : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, retain) RACCommand *codeCommand;

@property (nonatomic, retain) RACCommand *submitCommand;
@end
