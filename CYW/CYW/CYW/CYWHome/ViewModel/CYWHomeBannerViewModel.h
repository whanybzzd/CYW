//
//  CYWHomeBannerViewModel.h
//  CYW
//
//  Created by jktz on 2017/11/6.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWHomeBannerViewModel : NSObject

@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *urlArray;

@property (nonatomic) RACCommand *refreshBannerCommand;

- (RACSignal *)refreshNewData;


@property (nonatomic, retain) NSMutableArray *articleArray;
@property (nonatomic, retain) NSMutableArray *articleIdArray;

@property (nonatomic) RACCommand *refreshArticCommand;

@end
