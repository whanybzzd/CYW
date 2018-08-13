//
//  CYWMoreUserCenterAuthenticationTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterAuthenticationTableViewCell.h"
@interface CYWMoreUserCenterAuthenticationTableViewCell()<UITextFieldDelegate>

@end
@implementation CYWMoreUserCenterAuthenticationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self textField];
        [self detailabel];
    }
    return self;
}

- (UITextField *)textField{
    if (!_textField) {
        
        _textField=[UITextField new];
        _textField.delegate=self;
        _textField.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_textField];
        _textField.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(100))
        .centerYEqualToView(self.contentView)
        .heightIs(40)
        .rightSpaceToView(self.contentView, CGFloatIn320(100));
    }
    return _textField;
}

- (UILabel *)detailabel{
    if (!_detailabel) {
        
        _detailabel=[UILabel new];
        _detailabel.text=@"2541*****4552";
        _detailabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _detailabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_detailabel];
        _detailabel.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(14);
        [_detailabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _detailabel;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
   AuthenticationViewModel *model =[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
    if (0==indexPath.row) {
        
        self.detailabel.text =[model.realname stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        
    }else if (1==indexPath.row){
        self.detailabel.text =[self replaceStringWithAsterisk:4 length:model.idCard.length-8 withCar:model.idCard];
        _textField.maxLength=20;
        
    }
    [self.detailabel sizeToFit];
}


- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length withCar:(NSString *)car {
    NSString *replaceStr = car;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}


@end
