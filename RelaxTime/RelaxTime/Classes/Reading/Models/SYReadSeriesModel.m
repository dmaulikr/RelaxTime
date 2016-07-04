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

+(NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"item_id":@"id"};
}

//处理<br>
-(NSString *)content{
    
    _content = [_content stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    
    return _content;
    
}

-(CGFloat)contentViewHeight{
    
    //计算label的高度
    CGRect titleRect =  [self.title boundingRectWithSize:CGSizeMake(_ReadTitleWidth, 200) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTitleFont]} context:nil];
    
    CGRect textRect = [self.content boundingRectWithSize:CGSizeMake(_ReadTextWidth, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTextFont]} context:nil];
    
    return _ReadPicToTop + _ReadPicHeight + _ReadPicToTitle + titleRect.size.height + _ReadTitleToText + textRect.size.height + _ReadTextToBottom;
    
}

@end

@implementation SYReadSeriousAuthor



@end