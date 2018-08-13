//
//  CYWExtenTableViewCell.m
//  CYW
//
//  Created by jktz on 2018/7/25.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "CYWExtenTableViewCell.h"
@interface CYWExtenTableViewCell()

@property (nonatomic, strong) NSMutableArray *labelArray;
@end
@implementation CYWExtenTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self initSubView];
        [self data];
    }
    return self;
}

- (NSMutableArray *)labelArray{
    
    if (!_labelArray) {
        
        _labelArray=[NSMutableArray array];
    }
    return _labelArray;
}

- (void)initSubView{
    
    for (int i = 0; i < 5; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH/5 + 25, 0, SCREEN_WIDTH/5 , 50)];
        
        label.tag = i;
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:label];
        [self.labelArray addObject:label];
    }
}

- (void)data{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(ExtenViewModel *viewModel) {
        
        @strongify(self)
        
        UILabel *label=self.labelArray[0];
        label.text=viewModel.period;
        
        UILabel *label1=self.labelArray[1];
        label1.text=viewModel.corpus;
        
        UILabel *label2=self.labelArray[2];
        label2.text=viewModel.interest;
        
        UILabel *label3=self.labelArray[3];
        label3.text=[viewModel.repayDay componentsSeparatedByString:@" "][0];
        
        UILabel *label4=self.labelArray[4];
        if ([viewModel.status isEqualToString:@"repaying"]) {
            
            label4.text=@"还款中";
        }
        else if ([viewModel.status isEqualToString:@"complete"]){
            
            label4.text=@"完成";
        }
        else if ([viewModel.status isEqualToString:@"extension"]){
            
            label4.text=@"展期计划生成成功";
        }
        else if ([viewModel.status isEqualToString:@"overdue"]){
            
            label4.text=@"逾期";
        }
        else if ([viewModel.status isEqualToString:@"cancel"]){
            
            label4.text=@"流标";
        }
        
    }];
    
}
@end
