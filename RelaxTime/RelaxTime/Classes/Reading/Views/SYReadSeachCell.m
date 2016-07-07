//
//  SYReadSeachCell.m
//  RelaxTime
//
//  Created by imac on 16/7/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadSeachCell.h"
#import "SYReadTopTwoModel.h"
@interface SYReadSeachCell()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation SYReadSeachCell

- (void)awakeFromNib {
    // Initialization code
    
    _typeLabel.layer.cornerRadius = 6;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.textColor = GlobalColorBLUE;
    _typeLabel.layer.borderColor = GlobalColorBLUE.CGColor;
    _typeLabel.layer.borderWidth = 1;
}

-(void)setModel:(SYReadTopTwoModel *)model{
    
    _model = model;
   
   // NSLog(@"%@",_model.type);
    //短篇 连载 问答
    if ([_model.type isEqualToString:@"essay"]) {
        _typeLabel.text = @"短文";
    }else if([_model.type isEqualToString:@"serialcontent"]){
        _typeLabel.text = @"连载";
    }else{
         _typeLabel.text = @"问答";
    }
    
    _titleLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
