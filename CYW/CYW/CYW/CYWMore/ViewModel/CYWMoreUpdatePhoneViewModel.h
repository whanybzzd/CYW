//
//  CYWMoreUpdatePhoneViewModel.h
//  CYW
//
//  Created by jktz on 2017/11/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWMoreUpdatePhoneViewModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic) RACCommand *refreshSendCodeCommand;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *op;
@property (nonatomic) RACCommand *refreshsubmitCommand;
@end
