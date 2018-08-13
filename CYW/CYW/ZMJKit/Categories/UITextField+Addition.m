//
//  UITextField+Addition.m
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import "UITextField+Addition.h"
#import <objc/runtime.h>

const char *ObjectTagKey;
@implementation UITextField (Addition)

static CGFloat ratio = 0;//这是为了只算一次不要浪费太多计算比例的性能
CGFloat CGFloatIn320(CGFloat value){
    if (ratio==0) {
        ratio = ([UIScreen mainScreen].bounds.size.width
                 >[UIScreen mainScreen].bounds.size.height
                 ?[UIScreen mainScreen].bounds.size.height
                 :[UIScreen mainScreen].bounds.size.width)/375.0;
    }
    return value;
}

- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, ObjectTagKey, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, ObjectTagKey) integerValue];
}

- (instancetype)initWithFont:(CGFloat)font keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder textColor:(NSString *)color{

    if (self=[super init]) {
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.borderStyle = UITextBorderStyleNone;
        self.returnKeyType = UIReturnKeyDone;
        self.font = [UIFont systemFontOfSize:font];
        self.keyboardType = keyboardType;
        self.placeholder = placeholder;
        [self setValue:[UIColor colorWithHexString:color] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return self;
}


+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
@end
