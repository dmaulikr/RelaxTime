//
//  SYPageControl.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/13.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYPageControl.h"

@implementation SYPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setCurrentPage:(NSInteger)currentPage{
 
        [super setCurrentPage:currentPage];
        for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
            UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
            CGSize size;
            size.height = 12;
            size.width = 12;
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                         size.width,size.height)];
          
        }
  
}
@end
