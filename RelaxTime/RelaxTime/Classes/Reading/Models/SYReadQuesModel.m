//
//  SYReadQuesModel.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadQuesModel.h"

@implementation SYReadQuesModel

+(NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"item_id":@"question_id"};
}

//处理<br>
-(NSString *)answer_content{
    
    _answer_content = [_answer_content stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    
    return _answer_content;
    
}



-(CGFloat)contentViewHeight{
    
    //计算label的高度
    CGRect titleRect =  [self.question_title boundingRectWithSize:CGSizeMake(_ReadTitleWidth, 200) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTitleFont]} context:nil];
    
    CGRect textRect1 = [self.question_content boundingRectWithSize:CGSizeMake(_ReadTextWidth, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTextFont]} context:nil];
    CGRect textRect2 = [self.answer_title boundingRectWithSize:CGSizeMake(_ReadTextWidth, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTextFont]} context:nil];
    CGRect textRect3 = [self.answer_content boundingRectWithSize:CGSizeMake(_ReadTextWidth, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_ReadTextFont]} context:nil];
    
    
    
    return _ReadPicToTop + _ReadPicHeight + _ReadPicToTitle + titleRect.size.height + _ReadTitleToText + textRect1.size.height + textRect2.size.height+textRect3.size.height+_ReadTextToBottom + 20;
    
}
@end
