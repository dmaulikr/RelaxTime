//
//  SYTextField.m
//  budejie
//
//  Created by qf on 16/5/26.
//  Copyright © 2016年 fuckyo. All rights reserved.
//

#import "SYTextField.h"


@implementation SYTextField


- (void)awakeFromNib {
    // ----设置光标颜色
    self.tintColor = self.textColor;
    
    self.placeholderColor = [UIColor lightGrayColor];
    self.placeholderSelectedColor = [UIColor whiteColor];
    [self resignFirstResponder];
}

/**
 *  设置未选中的占位符颜色
 *
 *  @return
 */
- (BOOL)resignFirstResponder {
    
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = self.placeholderColor;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    self.attributedPlaceholder = str;
    
    return [super resignFirstResponder];
}

/**
 *  设置选中的占位符颜色
 *
 *  @return
 */
- (BOOL)becomeFirstResponder {
    
  
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = self.placeholderSelectedColor;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    self.attributedPlaceholder = str;
    return [super becomeFirstResponder];
}

@end
