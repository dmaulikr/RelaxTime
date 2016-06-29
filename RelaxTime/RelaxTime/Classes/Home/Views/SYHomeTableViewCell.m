//
//  SYHomeTableViewCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeTableViewCell.h"

@implementation SYHomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
