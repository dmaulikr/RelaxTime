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


+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"item_id":@"content_id"};
}


//处理<br>
-(NSString *)hp_content{
    
    _hp_content = [_hp_content stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
   
   _hp_content = [_hp_content componentsSeparatedByString:@"<embed"][0];
    
   
    return _hp_content;

}

//返回高度
-(CGFloat)contentViewHeight{
    

    //计算label的高度
    CGRect titleRect =  [self.hp_title boundingRectWithSize:CGSizeMake(_ReadTitleWidth, 200) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTitleFont]} context:nil];
    
   CGRect textRect = [self.hp_content boundingRectWithSize:CGSizeMake(_ReadTextWidth, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTextFont]} context:nil];
    
    return _ReadPicToTop + _ReadPicHeight + _ReadPicToTitle + titleRect.size.height + _ReadTitleToText + textRect.size.height + _ReadTextToBottom;

}

@end

@implementation SYReadEssayAuthor


@end
