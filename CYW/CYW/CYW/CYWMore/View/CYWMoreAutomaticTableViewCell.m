//
//  CYWMoreAutomaticTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreAutomaticTableViewCell.h"
#import "CYWMoreAutomaticViewModel.h"
@interface CYWMoreAutomaticTableViewCell()
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) CYWMoreAutomaticViewModel *automaticViewModel;


@end
@implementation CYWMoreAutomaticTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.automaticViewModel=[[CYWMoreAutomaticViewModel alloc] init];
        
        [self label];
        [self switchs];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    @weakify(self)
    if ([NSObject isNotEmpty:[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuto]]) {
        
        self.switchs.on=YES;
    }else{
        
        self.switchs.on=NO;
    }
    NSObject *centerModel= [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCenterInfoModel];
    UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)centerModel;
    
    
    [[self.switchs rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self)
        //当如果用户
        NSLog(@"开关机器:%zd",self.switchs.on);
        if (self.switchs.on) {
            
            if ([model.balcance floatValue]<1000) {
                
                self.switchs.on=NO;//禁止开启
                [UIView showResultThenHide:@"余额不足，开启自动投标余额需大于等于1000元"];
                return ;
            }
            [self selectOn:x];
        }else{
            
            //关闭
            [self selectOn:x];
            [self.automaticViewModel.autoCloseCommand execute:x];
            
        }
        
        
       
       
    }];
}

- (void)selectOn:(UIControl *)control{
    
    UISwitch *swit=(UISwitch *)control;
    if (self.select) {
        
        self.select(swit.isOn);
    }
}
- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"自动投标";
        _label.textColor=[UIColor colorWithHexString:@"#666666"];
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label;
}
- (UISwitch *)switchs{
    if (!_switchs) {
        
        _switchs=[UISwitch new];
        [self.contentView addSubview:_switchs];
        _switchs.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .centerYEqualToView(self.contentView);
    }
    return _switchs;
}
@end
