//
//  SYReadCommentModel.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadCommentModel.h"

@implementation SYReadCommentModel


+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"user": [SYReadCommentUser class]};
}

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"_id":@"id"};
}
@end

@implementation SYReadCommentUser

//

@end
