//
//  CYWMoreUserCenSetAutoViewController.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//
#import <GTMBase64/GTMBase64.h>
#import "CYWMoreUserCenSetAutoViewController.h"
#import "CYWMoreUserCenterViewModel.h"
#import "NSData+Addition.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface CYWMoreUserCenSetAutoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, retain) UIImageView *avaterImageView;
@property (nonatomic, retain) UIView *cacheView;
@property (nonatomic, retain) UIView *photoView;
@property (nonatomic, retain) CYWMoreUserCenterViewModel *centerViewModel;


@end

@implementation CYWMoreUserCenSetAutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"设置头像";
    self.centerViewModel=[[CYWMoreUserCenterViewModel alloc] init];
    
    [self cacheView];
    [self photoView];
    [self avaterImageView];
    
    
    [self initSubView];
    [self loadAvater];
    
}
- (void)loadAvater{
    
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    if ([NSObject isNotEmpty:mo]) {
        
        NSLog(@"执行了该方法");
        [self.avaterImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,mo.photo]] placeholder:[UIImage imageNamed:@"icon_avater"]];
        
    }
}
- (void)initSubView{
    
    
    @weakify(self)
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
    [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self cacheImagePhoto:1];
    }];
    [self.cacheView addGestureRecognizer:tapView];
    
    
    UITapGestureRecognizer *tapView1=[[UITapGestureRecognizer alloc] init];
    [[tapView1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        
        @strongify(self)//拍照
        [self cacheImagePhoto:0];
        
    }];
    [self.photoView addGestureRecognizer:tapView1];
}

- (void)cacheImagePhoto:(NSInteger)row{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    if (row == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.allowsEditing = YES;
        picker.editing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }else if (row == 0){
        
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.editing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}


//pick代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        self.centerViewModel.photo=[GTMBase64 stringByEncodingData:data];
        //NSLog(@"data:%@",data);
        [self loadAvaterImageView];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)loadAvaterImageView{
    
    @weakify(self)
    [self showHUDLoading:nil];
    [[self.centerViewModel.refreshCenterAvaterCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"上传头像刷新视图");
        @strongify(self)
        [self showResultThenHide:@"上传成功"];
        //暂停2s执行  可以刷新头像
        [self bk_performBlock:^(id obj) {
            
           [self loadAvater];
            
        } afterDelay:2.0];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self showResultThenHide:(NSString *)error];
        
    }];
}


- (UIImageView *)avaterImageView{
    if (!_avaterImageView) {
        
        _avaterImageView=[UIImageView new];
        _avaterImageView.backgroundColor=[UIColor clearColor];
        [_avaterImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _avaterImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _avaterImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _avaterImageView.clipsToBounds  = YES;
        [self.view addSubview:_avaterImageView];
        _avaterImageView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(_cacheView, CGFloatIn320(50));
    }
    return _avaterImageView;
}

- (UIView *)cacheView{
    
    if (!_cacheView) {
        
        _cacheView=[UIView new];
        _cacheView.userInteractionEnabled=YES;
        _cacheView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_cacheView];
        _cacheView.sd_layout
        .leftSpaceToView(self.view, 0)
        .widthIs(SCREEN_WIDTH/2)
        .heightIs(CGFloatIn320(77))
        .bottomSpaceToView(self.view, CGFloatIn320(50));
        
        
        UIImageView *imageView=[UIImageView new];
        imageView.layer.cornerRadius=CGFloatIn320(25);
        imageView.image=[UIImage imageNamed:@"icon_user_album"];
        [_cacheView addSubview:imageView];
        imageView.sd_layout
        .centerXEqualToView(_cacheView)
        .topSpaceToView(_cacheView, 0)
        .widthIs(CGFloatIn320(50))
        .heightIs(CGFloatIn320(50));
        
        UILabel *label=[UILabel new];
        label.text=@"从相册选择";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        label.textColor=[UIColor colorWithHexString:@"#666666"];
        [_cacheView addSubview:label];
        label.sd_layout
        .centerXEqualToView(_cacheView)
        .topSpaceToView(imageView, CGFloatIn320(10))
        .heightIs(12);
        [label setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _cacheView;
}

- (UIView *)photoView{
    
    if (!_photoView) {
        
        _photoView=[UIView new];
        _photoView.userInteractionEnabled=YES;
        _photoView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_photoView];
        _photoView.sd_layout
        .rightSpaceToView(self.view, 0)
        .widthIs(SCREEN_WIDTH/2)
        .heightIs(CGFloatIn320(77))
        .bottomSpaceToView(self.view, CGFloatIn320(50));
        
        UIImageView *imageView=[UIImageView new];
        imageView.layer.cornerRadius=CGFloatIn320(25);
        imageView.image=[UIImage imageNamed:@"icon_user_photo"];
        [_photoView addSubview:imageView];
        imageView.sd_layout
        .centerXEqualToView(_photoView)
        .topSpaceToView(_photoView, 0)
        .widthIs(CGFloatIn320(50))
        .heightIs(CGFloatIn320(50));
        
        UILabel *label=[UILabel new];
        label.text=@"拍一张";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        label.textColor=[UIColor colorWithHexString:@"#666666"];
        [_photoView addSubview:label];
        label.sd_layout
        .centerXEqualToView(_photoView)
        .topSpaceToView(imageView, CGFloatIn320(10))
        .heightIs(12);
        [label setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _photoView;
}

- (void)dealloc{
    NSLog(@"设置头像销毁");
}
@end
