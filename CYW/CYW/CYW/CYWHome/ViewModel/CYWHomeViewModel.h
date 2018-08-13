//
//  CYWHomeViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWHomeViewModel : NSObject
//@property (nonatomic, assign) NSInteger refreshIndex;
@property (nonatomic, retain) NSMutableArray *noviceArray;
@property (nonatomic, retain) NSMutableArray *dataModelArray;
//@property (nonatomic) RACCommand *refreshHomeCommand;
- (RACSignal *)refreshNewData;
@end
