//
//  CYWNowInvestmentTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWNowInvestmentTableViewCell.h"
@interface CYWNowInvestmentTableViewCell()<UITextFieldDelegate>
@end
@implementation CYWNowInvestmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self detailabel];
        [self textField];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath=indexPath;
    
    if (indexPath.section==0) {
        if (indexPath.row>=4) {
            
            self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            self.textLabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        }
        
        
    }else if (indexPath.section==1){
        self.detailabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"envelopename"];
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    }else if (indexPath.section==2){
        
        [self.textField setHidden:NO];
        self.detailabel.text=@"元";
    }
}


- (UILabel *)detailabel{
    if (!_detailabel) {
        
        _detailabel=[UILabel new];
        _detailabel.text=@"普通标";
        _detailabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _detailabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_detailabel];
        _detailabel.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(5))
        .heightIs(14)
        .centerYEqualToView(self.contentView);
        [_detailabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _detailabel;
}

- (UITextField *)textField{
    
    if (!_textField) {
        
        _textField=[UITextField new];
        [_textField setHidden:YES];
        _textField.delegate=self;
        _textField.font=[UIFont systemFontOfSize:14];
        _textField.placeholder=@"起投金额50元";
        [self.contentView addSubview:_textField];
        _textField.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(50))
        .heightIs(40)
        .centerYEqualToView(self.contentView);
    }
    return _textField;
}


//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    if (self.textField==textField) {
        
        return [self validateNumber:string];
        
    }
    //否则返回yes,不限制其他textfield
    return YES;
    
}


- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
@end
