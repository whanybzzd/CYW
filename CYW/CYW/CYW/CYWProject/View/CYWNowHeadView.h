//
//  CYWNowHeadView.h
//  CYW
//
//  Created by jktz on 2017/10/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NowHeadViewBook)(BOOL section);
@interface CYWNowHeadView : UIView
@property (nonatomic, copy)NowHeadViewBook nowHeadViewBook;

- (void)withModel:(ProjectViewModel *)model;

- (void)TransformModel:(TransferRepayViewModel *)model;


@end
