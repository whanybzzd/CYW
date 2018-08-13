//
//  AssetsWithdrawalsTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//




#import <UIKit/UIKit.h>
@protocol AssetsWithdrawalsTableViewCellDelegate<NSObject>
- (void)labelClick;
@end

@interface AssetsWithdrawalsTableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *titlabel;
@property (nonatomic, retain) UILabel *detailabel;
@property (nonatomic, retain) NSString *titlestring;
@property (nonatomic, assign) id<AssetsWithdrawalsTableViewCellDelegate>delegate;
@end


