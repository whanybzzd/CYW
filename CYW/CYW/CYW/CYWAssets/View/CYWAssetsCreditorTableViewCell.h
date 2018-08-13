//
//  CYWAssetsCreditorTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

@protocol CYWAssetsCreditorTableViewCellDelegate;
#import <UIKit/UIKit.h>
@interface CYWAssetsCreditorTableViewCell : UITableViewCell
@property (nonatomic, retain) CreditorViewModel *model;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, weak) id<CYWAssetsCreditorTableViewCellDelegate>delegate;

@end


@protocol CYWAssetsCreditorTableViewCellDelegate<NSObject>


/**
 区分

 @param identi 标识符
 @param indexPath 下标
 */
- (void)tableViewCellIdenti:(NSString *)identi indexPath:(NSIndexPath *)indexPath;

@end
