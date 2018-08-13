


@end
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)

+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector;

+ (instancetype)itemWithBtnImage:(NSString *)image target:(id)obj action:(SEL)selector;
@end

