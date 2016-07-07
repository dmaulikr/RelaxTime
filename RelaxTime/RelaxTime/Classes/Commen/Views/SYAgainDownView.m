//
//  SYAgainDownView.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/7.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYAgainDownView.h"

@interface SYAgainDownView()

@property(nonatomic ,strong) UILabel * label;
@property(nonatomic ,strong) UIImageView * imageView;

@end

@implementation SYAgainDownView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.label = [[UILabel alloc]init];
        
        self.label.text = @"加载失败\n点击重新加载";
        self.label.textColor = [UIColor lightGrayColor];
        
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter ;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.label];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]init];
        
        self.label.text = @"加载失败\n点击重新加载";
        self.label.textColor = [UIColor lightGrayColor];
        
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter ;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.label];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)layoutSubviews{
    
    self.label.frame = CGRectMake(0, 0, 100, 40);
    self.label.center = CGPointMake(self.width/2,self.height/2);
   
    
}

-(void)tap{
     
    self.block();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
