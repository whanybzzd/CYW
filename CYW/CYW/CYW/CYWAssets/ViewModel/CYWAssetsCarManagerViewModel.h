//
//  CYWAssetsCarManagerViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsCarManagerViewModel : BaseViewModel
@property (nonatomic, retain) NSMutableArray *datassetslArray;
@property (nonatomic, retain) NSString *deleteCarId;
@property (nonatomic) RACCommand *refresBindCommand; /**< 请求 */

@property (nonatomic) RACCommand *refresDeleteCommand; /**< 请求 */
@end
