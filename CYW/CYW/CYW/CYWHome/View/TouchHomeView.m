//
//  TouchHomeView.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "TouchHomeView.h"
@interface TouchHomeView()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *closeImageView;
@end
@implementation TouchHomeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.isKeepBounds=YES;
        self.backgroundColor = [UIColor clearColor];
        [self backImageView];
        [self closeImageView];
        
    }
    return self;
}




- (UIImageView *)backImageView{
    if (!_backImageView) {
        
       __weak BaseViewController *baseVC=(BaseViewController *)[UIView currentViewController];
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backImageView.userInteractionEnabled=YES;
        _backImageView.image=[UIImage imageNamed:@"达人"];
        [_backImageView bk_whenTapped:^{
            
            [baseVC pushViewController:@"CYWFinanceViewController"];
        }];
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (UIImageView *)closeImageView{
    if (!_closeImageView) {
        
        _closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-25, 0, 25, 25)];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"关闭s"];
        WeakSelfType blockSelf=self;
        [_closeImageView bk_whenTapped:^{
            
            [blockSelf removeFromSuperview];
        }];
        [self addSubview:_closeImageView];
    }
    return _closeImageView;
}
@end
