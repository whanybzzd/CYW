//
//  CYWMoreSettingGuesturesTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/25.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreSettingGuesturesTableViewCell.h"
@interface CYWMoreSettingGuesturesTableViewCell()
@property (nonatomic, retain) UISwitch *switchs;

@end
@implementation CYWMoreSettingGuesturesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [self label];
        [self switchs];
        
        [self initSubView];
        
        @weakify(self)
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"switch" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
            
            NSLog(@"通知");
            @strongify(self)
            [self initSubView];
            
        }];
        
    }
    return self;
    
}

- (void)initSubView{
    
    NSInteger on=[[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] integerValue];
    self.switchs.on=on==1?YES:NO;
    
    
    @weakify(self)
    [[self.switchs rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        UISwitch *swit=(UISwitch *)x;
        if (self.switchSelect) {
            
            self.switchSelect(swit.isOn);
        }
        
        
    }];
    
}


- (UILabel *)label{
    
    if (!_label) {
        
        _label=[UILabel new];
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _label.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .centerYEqualToView(self.contentView)
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _label;
}


- (UISwitch *)switchs{
    if (!_switchs) {
        
        _switchs=[UISwitch new];
        [_switchs setHidden:YES];
        [self.contentView addSubview:_switchs];
        _switchs.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .centerYEqualToView(self.contentView);
    }
    return _switchs;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0&&indexPath.row==0) {
        
         [self.switchs setHidden:NO];
    }else if(indexPath.section==0&&indexPath.row==1){
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
}


- (void)dealloc{
    NSLog(@"设置界面销毁");
}
@end
