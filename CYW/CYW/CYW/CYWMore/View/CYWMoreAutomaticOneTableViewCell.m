//
//  CYWMoreAutomaticOneTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreAutomaticOneTableViewCell.h"
@interface CYWMoreAutomaticOneTableViewCell()
@property (nonatomic, retain) UILabel *label;
@end
@implementation CYWMoreAutomaticOneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self label];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    
}


- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"\n\n1、借款进入招标中1分钟后，系统开启自动投标。\n2、投标进度达到100%时停止自动投标，若剩余自动投标金额小于用户设定的每次投标金额，也会进行投标，投资金额乡下取该标剩余自动投标金额。\n3、单笔投标金额若超过该标单笔最大投资额，则向下取该标最大投资额。\n4、投标排序规则如下：\n    a）投标序列按照开启自动投标的时间先后进行排序。\n    b）每个用户每个标仅自动投标一次，投标后，排到队尾。\n    c）轮到用户投标时没有符合用户条件的标，该用户会继续保持在最前，直到投入。";
        _label.textColor=[UIColor colorWithHexString:@"#666666"];
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .autoHeightRatio(0);
    }
    return _label;
}
@end
