//
//  SYSegmentController.m
//  -04 自定义分段选择器
//
//  Created by 千锋 on 16/5/25.
//  Copyright (c) 2016年 abc. All rights reserved.
//

#import "SYSegmentController.h"
#define Button_tag 100
@interface SYSegmentController(){
    id _target;
    SEL _action;
    //底部的线
    
    UIView * _lineView;
    UIView * _sliderView;
  
    
}

@property(nonatomic, strong )NSMutableArray *items;

@end

@implementation SYSegmentController


#pragma mark - 懒加载
-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

#pragma mark - 初始化方法
-(instancetype)initWithItems:(NSArray *)items{
    if (self = [super init]) {
        [self.items addObjectsFromArray:items];
        //初始化所有的属性
        [self myInit];
        
    }
    return self;
}

//初始化所有的默认属性
-(void)myInit{
    
    self.fontSize = 14;
    self.scale = 1.2;
    self.titleColor = [UIColor redColor];
    _lineView = [[UIView alloc]init];
    [self addSubview:_lineView];
    _sliderView = [[UIView alloc]init];
    [self addSubview:_sliderView];
}
#pragma mark - 创建按钮

-(void)layoutSubviews{
    
    [self creatButton];
    
    [self bringSubviewToFront:_lineView];
    
    CGFloat lineX = 0;
    CGFloat lineH = 1.5;
    CGFloat lineW = self.frame.size.width;
    CGFloat lineY = self.frame.size.height - lineH;
    _lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
    _lineView.backgroundColor = self.titleColor;
    
    [self bringSubviewToFront:_sliderView];
    _sliderView.backgroundColor = self.titleColor;
    CGFloat sliderW = self.frame.size.width / self.items.count;
    CGFloat sliderH = 3;
    CGFloat sliderX = self.selectedSegmentIndex * sliderW;
    CGFloat sliderY = lineY - sliderH;
    _sliderView .frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    
}

-(void)creatButton{
    
    CGFloat buttonW = self.frame.size.width / self.items.count;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    for (int i = 0 ; i < self.items.count; i ++) {
        UIButton *button = [[UIButton alloc]init];
        //设置frame
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //设置文字
        [button setTitle:self.items[i] forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        //设置文字大小
        button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        //添加事件
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
        button.tag = i + Button_tag;
        
        //默认选中
        if (i == self.selectedSegmentIndex) {
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:_fontSize * _scale];
        }
        [self addSubview:button];
    }

}

#pragma mark - 按钮点击事件
-(void)onClick:(UIButton *)button{
 
    //如果按钮不是之前点击的就执行
    if (button.tag != _selectedSegmentIndex + Button_tag) {
        //将之前的按钮文字变回原来大小
        
        self.selectedSegmentIndex = (int)button.tag - Button_tag;
        
         [_target performSelector:_action withObject:self];
    }
}

-(void)setSelectedSegmentIndex:(int)selectedSegmentIndex{
    
    if (_selectedSegmentIndex != selectedSegmentIndex) {
    
        //找出之前的变小
        UIButton *btn = (UIButton *)[self viewWithTag:Button_tag + _selectedSegmentIndex];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        
        //
        _selectedSegmentIndex = selectedSegmentIndex;
        
        //将选中的按钮文字变大
          UIButton *button = (UIButton *)[self viewWithTag:Button_tag + _selectedSegmentIndex];
        button.titleLabel.font = [UIFont systemFontOfSize:_scale * _fontSize];
        
       
        //滑块
        [UIView animateWithDuration:0.2 animations:^{
            _sliderView .frame = CGRectMake(button.frame.origin.x, _sliderView.frame.origin.y, _sliderView.frame.size.width , _sliderView.frame.size.height );
        }];

    }
    
}

//-(void)setSelectedSegmentIndex:(int)selectedSegmentIndex{
//    
//    if (_selectedSegmentIndex != selectedSegmentIndex) {
//        //改变selectedSegmentIndex
//        _selectedSegmentIndex = selectedSegmentIndex;
//        
//        //遍历按钮 设置相应按钮的状态
//        for (int i = 0; i < _items.count; i ++) {
//            UIButton *button = (UIButton *)[self viewWithTag:Button_tag + i];
//            if (i == selectedSegmentIndex) {
//                
//                button.titleLabel.font = [UIFont systemFontOfSize:_scale * _fontSize];
//                [UIView animateWithDuration:0.2 animations:^{
//                    _sliderView .frame = CGRectMake(button.frame.origin.x, _sliderView.frame.origin.y, _sliderView.frame.size.width , _sliderView.frame.size.height );
//                }];
//                
//                
//                //button.userInteractionEnabled = NO;
//            }else{
//                button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
//                //button.userInteractionEnabled = YES;
//            }
//        }
//
//    }
//    
//}
//
#pragma mark - 添加事件
-(void)addTarget:(id)target action:(SEL)action{
   
    _target = target;
    
    _action = action;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
