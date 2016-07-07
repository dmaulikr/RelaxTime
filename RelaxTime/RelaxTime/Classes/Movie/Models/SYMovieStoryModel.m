//
//  SYMovieStoryModel.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieStoryModel.h"

@implementation SYMovieStoryModel


+ (NSDictionary *) modelCustomPropertyMapper {
    
    return @{@"ID":@"id"};
}

-(CGFloat)storyHeight{

    CGRect rect = [self.content boundingRectWithSize:CGSizeMake(WIDTH -20- 40 -10 - 15 , CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    return rect.size.height;
    
}


@end



@implementation storyUser

@end
