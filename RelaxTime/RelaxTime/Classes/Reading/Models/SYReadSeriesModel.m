//
//  SYReadSeriesModel.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadSeriesModel.h"

@implementation SYReadSeriesModel


+(NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"author":[SYReadSeriousAuthor class]};
    
}

@end

@implementation SYReadSeriousAuthor



@end