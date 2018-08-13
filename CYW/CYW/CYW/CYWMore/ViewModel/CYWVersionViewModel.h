//
//  CYWVersionViewModel.h
//  CYW
//
//  Created by jktz on 2017/11/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWVersionViewModel : NSObject
@property (nonatomic, retain) NSMutableArray *dataModelArray;
@property (nonatomic) RACCommand *refreshVersionCommand;
@end
