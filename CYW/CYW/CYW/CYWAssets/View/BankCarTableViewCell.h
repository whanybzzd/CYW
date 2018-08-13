//
//  BankCarTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BankCarTableViewCellResultBlock)(NSIndexPath *indexPath);
@interface BankCarTableViewCell : UITableViewCell
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) void(^qhxSelectBlock)(BOOL choice,NSInteger btntag);
@property (nonatomic, retain) UIImageView *rightImageView;
@property (nonatomic, retain) BankCarTableViewCellResultBlock resultBlock;
@property (nonatomic, retain) CarManagerMentViewModel *model;
@end
