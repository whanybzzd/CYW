//
//  CYWAssetsMessageTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsMessageTableViewCell.h"
@interface CYWAssetsMessageTableViewCell()

@property (nonatomic, retain) UIImageView *jpushImageView;
@property (nonatomic, retain) UILabel *jpushTitlelabel;
@property (nonatomic, retain) UILabel *jpushContentlabel;
@property (nonatomic, retain) UILabel *jpushTimelabel;

@end
@implementation CYWAssetsMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [self jpushImageView];
        [self jpushTitlelabel];
        [self jpushContentlabel];
        [self jpushTimelabel];
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(JpushViewModel *viewModel) {
        
        @strongify(self);
        
        self.jpushTitlelabel.text=viewModel.title;
        [self.jpushTitlelabel sizeToFit];
        
        self.jpushContentlabel.text=viewModel.content;
        [self.jpushContentlabel sizeToFit];
        
        self.jpushTimelabel.text=viewModel.editTime;
        [self.jpushTimelabel sizeToFit];
        
        
        if ([viewModel.type intValue]==1) {

            self.jpushImageView.image=[UIImage imageNamed:@"jpush消息2"];

        }else  if ([viewModel.type intValue]==2) {

            self.jpushImageView.image=[UIImage imageNamed:@"jpush消息3"];
        }
        else  if ([viewModel.type intValue]==3) {

            self.jpushImageView.image=[UIImage imageNamed:@"jpush消息"];
        }
    }];
}

- (UIImageView *)jpushImageView{
    
    if (!_jpushImageView) {
        
        _jpushImageView=[UIImageView new];
        
        [self.contentView addSubview:_jpushImageView];
        _jpushImageView.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .centerYEqualToView(self.contentView)
        .widthIs(45)
        .heightIs(45);
    }
    return _jpushImageView;
}
- (UILabel *)jpushTitlelabel{
    
    if (!_jpushTitlelabel) {
        
        _jpushTitlelabel=[UILabel new];
        _jpushTitlelabel.font=[UIFont systemFontOfSize:15];
        _jpushTitlelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_jpushTitlelabel];
        _jpushTitlelabel.sd_layout
        .leftSpaceToView(_jpushImageView, 15)
        .heightIs(15)
        .topSpaceToView(self.contentView, 22);
        [_jpushTitlelabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width-75];
    }
    return _jpushTitlelabel;
}

- (UILabel *)jpushContentlabel{
    
    if (!_jpushContentlabel) {
        
        _jpushContentlabel=[UILabel new];
        _jpushContentlabel.font=[UIFont systemFontOfSize:14];
        _jpushContentlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_jpushContentlabel];
        _jpushContentlabel.sd_layout
        .leftSpaceToView(_jpushImageView, 14)
        .topSpaceToView(_jpushTitlelabel, 19)
        .heightIs(14);
        [_jpushContentlabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width-75];
    }
    return _jpushContentlabel;
}

- (UILabel *)jpushTimelabel{
    
    if (!_jpushTimelabel) {
        
        _jpushTimelabel=[UILabel new];
        _jpushTimelabel.font=[UIFont systemFontOfSize:14];
        _jpushTimelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        
        [self.contentView addSubview:_jpushTimelabel];
        _jpushTimelabel.sd_layout
        .rightSpaceToView(self.contentView, 0)
        .heightIs(15)
        .centerYEqualToView(self.contentView);
        [_jpushTimelabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _jpushTimelabel;
}
@end
