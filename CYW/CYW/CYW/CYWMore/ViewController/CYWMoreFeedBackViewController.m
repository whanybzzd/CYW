//
//  CYWMoreFeedBackViewController.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreFeedBackViewController.h"
#import "FSTextView.h"
#import "CYWMoreViewModel.h"
@interface CYWMoreFeedBackViewController ()
@property (nonatomic, retain) FSTextView *fsTextView;
@property (nonatomic, retain) UILabel *labelCount;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) CYWMoreViewModel *moreViewModel;

@end

@implementation CYWMoreFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
    self.navigationItem.title=@"意见反馈";
    self.moreViewModel=[[CYWMoreViewModel alloc] init];
    
    [self fsTextView];
    [self labelCount];
    [self submitButton];
    
    [self initSubView];
    
}

- (void)initSubView{
    
    RAC(self.moreViewModel,text)=self.fsTextView.rac_textSignal;
    
    @weakify(self)
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.fsTextView.rac_textSignal] reduce:^(NSString *username){
        
        return @([NSString isNotEmpty:username]);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#D72F3A"]:[UIColor lightGrayColor];
    }];
    
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
       [self hideKeyboard];
        [self showHUDLoading:@"正在反馈..."];
        [[self.moreViewModel.refreshAboutCommand execute:x] subscribeNext:^(id  _Nullable x) {
            
            [self showResultThenHide:@"反馈成功"];
        } error:^(NSError * _Nullable error) {
            [self showResultThenHide:(NSString *)error];
        }];//发送一个信号
    }];
}
- (FSTextView *)fsTextView{
    
    if (!_fsTextView) {
        
        _fsTextView=[FSTextView new];
        _fsTextView.placeholder=@"欢迎你向我们提宝贵意见";
        _fsTextView.layer.cornerRadius=5.0f;
        _fsTextView.backgroundColor=[UIColor whiteColor];
        _fsTextView.maxLength = 200;
        // 弱化引用, 以免造成内存泄露.
        WeakSelfType blockSelf=self;
        // 添加输入改变Block回调.
        [_fsTextView addTextDidChangeHandler:^(FSTextView *textView) {
            (textView.text.length < textView.maxLength) ? blockSelf.labelCount.text = [NSString stringWithFormat:@"%zd/200字以内", textView.text.length]:NULL;
            [blockSelf.labelCount sizeToFit];
        }];
        // 添加到达最大限制Block回调.
        [_fsTextView addTextLengthDidMaxHandler:^(FSTextView *textView) {
            blockSelf.labelCount.text = [NSString stringWithFormat:@"超过%zi个字符", textView.maxLength];
            [blockSelf.labelCount sizeToFit];
        }];
        [self.view addSubview:_fsTextView];
        _fsTextView.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(10))
        .rightSpaceToView(self.view, CGFloatIn320(10))
        .topSpaceToView(self.view, CGFloatIn320(kDevice_Is_iPhoneX?98:74))
        .heightIs(CGFloatIn320(153));
    }
    return _fsTextView;
}
- (UILabel *)labelCount{
    if (!_labelCount) {
        
        _labelCount=[UILabel new];
        _labelCount.text=@"最多200个字符";
        _labelCount.textColor=[UIColor colorWithHexString:@"#f52735"];
        _labelCount.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self.view addSubview:_labelCount];
        _labelCount.sd_layout
        .rightSpaceToView(self.view, CGFloatIn320(10))
        .topSpaceToView(_fsTextView, CGFloatIn320(15))
        .heightIs(12);
        [_labelCount setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _labelCount;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"确认" forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self.view addSubview:_submitButton];
        _submitButton.sd_layout
        .leftEqualToView(_fsTextView)
        .rightEqualToView(_fsTextView)
        .heightIs(CGFloatIn320(40))
        .topSpaceToView(_labelCount, CGFloatIn320(20));
    }
    return _submitButton;
}

- (void)dealloc{
    
    NSLog(@"意见反馈销毁");
}
@end
