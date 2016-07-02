//
//  SYReadEssayModel.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadEssayModel.h"

@implementation SYReadEssayModel


//将当前模型中指定的属性的元素转换成指定的类型
+(NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"author":[SYReadEssayAuthor class]};
}



@end

@implementation SYReadEssayAuthor


@end
