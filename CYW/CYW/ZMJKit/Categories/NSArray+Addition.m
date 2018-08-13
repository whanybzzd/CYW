//
//  NSArray+Addition.m
//  coffee
//
//  Created by App on 15/8/12.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import "NSArray+Addition.h"

@implementation NSArray (Addition)

//冒泡排序

+(NSArray*)bubble_SortArray:(NSArray*)oldArray{
    NSMutableArray * newArray = [NSMutableArray arrayWithArray: oldArray];
    NSUInteger num = [oldArray count];
    
    for(int i = 0 ; i < num-1 ; i++)
        
    {
        
        for(int j = i +1; j < num ; j++)
            
        {
            
            double num1 = [[newArray objectAtIndex: i] doubleValue];
            
            double num2 = [[newArray objectAtIndex: j] doubleValue];
            
            if(num1 < num2)
                
            {
                
                [newArray replaceObjectAtIndex: i  withObject:[NSString stringWithFormat:@"%lf",num2]];
                
                [newArray replaceObjectAtIndex: j  withObject:[NSString stringWithFormat:@"%lf",num1]];
                
            }
            
        }
        
    }
    return newArray;
    
}

@end
