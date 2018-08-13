//
//  CYWMoreViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWMoreViewModel : BaseViewModel
@property (nonatomic, copy) NSString *text;
@property (nonatomic) RACCommand *refreshAboutCommand;
@end
