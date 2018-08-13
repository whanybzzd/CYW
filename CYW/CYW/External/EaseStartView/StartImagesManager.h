//
//  StartImagesManager.h
//  CYW
//
//  Created by jktz on 2017/12/8.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StartManagerFile)(UIImage *fileName);
@interface StartImagesManager : NSObject
@property (copy, nonatomic) StartManagerFile files;
+ (instancetype)sharedInstance;
- (void)managerFile:(StartManagerFile)file;
- (UIImage *)image;
@end

