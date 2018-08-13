//
//  EaseStartView.m
//  CYW
//
//  Created by jktz on 2017/12/8.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "EaseStartView.h"
#import "StartImagesManager.h"
@interface EaseStartView()
@property (nonatomic, retain) UIImageView *backImageView;
@end
@implementation EaseStartView

+ (instancetype)startView{
    
    return [[self alloc] init];
}

- (instancetype)init{
    
    if (self=[super init]) {
        WeakSelfType blockSelf=self;
        self.frame=[UIScreen mainScreen].bounds;
        [self backImageView];
        
        [[StartImagesManager sharedInstance] managerFile:^(UIImage *fileName) {
            
            [blockSelf imageFile:fileName];
            
        }];
        [self startAnimationView];
        [self hideAnimationView];
    }
    return self;
}

- (void)imageFile:(UIImage *)file{
    
    self.backImageView.image=file;
    
}



- (UIImageView *)backImageView{
    
    if (!_backImageView) {
        
        _backImageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backImageView.contentMode=UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds =YES;//是否剪切掉超出UIImageView范围的图片
        _backImageView.image=[UIImage imageNamed:@"画板1"];//默认  不然会有空白一闪的情况
        [self addSubview:_backImageView];
    }
    return _backImageView;
}



//添加到Window上面
- (void)startAnimationView{
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

//隐藏图片
- (void)hideAnimationView{
    
    
    [UIView animateWithDuration:4 animations:^{
        //self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
    
}

- (void)removeGuidePageHUD{
    
    [self removeFromSuperview];
}
@end
