//
//  SYHomeModel.m
//  RelaxTime
//
//  Created by imac on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeModel.h"

#define wordSpace 5
@implementation SYHomeModel


-(CGFloat)cellHeight{
    
    if (_cellHeight == 0) {
        //cell高度 文字再左右距离 5
        CGFloat cellWidth = (WIDTH - MarginCell* 2) / 2;
        
        
        CGRect rect = [self.hp_content boundingRectWithSize:CGSizeMake(cellWidth- 10, 10000) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        //NSLog(@"%f",rect.size.height);
        CGFloat picHeight = cellWidth * 3 / 4;//图片比例
        
        _cellHeight = picHeight + wordSpace + rect.size.height + wordSpace;
       
     
    }
    return _cellHeight;

}

-(NSString *)last_update_date{
    return [[_last_update_date componentsSeparatedByString:@" "]firstObject];
}
@end
