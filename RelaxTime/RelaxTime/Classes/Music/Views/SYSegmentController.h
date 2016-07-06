//
//  SYSegmentController.h
//  -04 自定义分段选择器
//
//  Created by 千锋 on 16/5/25.
//  Copyright (c) 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYSegmentController : UIView

//选中下标
@property(nonatomic, assign) int selectedSegmentIndex;

//文字颜色
@property(nonatomic, strong) UIColor *titleColor;

//文字大小
@property(nonatomic, assign) CGFloat fontSize;

//选中文字变大比例
@property(nonatomic, assign) double scale;

//通过items来创建分段选择器
-(instancetype)initWithItems:(NSArray *)items;

-(void)addTarget:(id)target action:(SEL)action;


@end
