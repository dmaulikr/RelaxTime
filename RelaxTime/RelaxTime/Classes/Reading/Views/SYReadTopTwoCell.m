//
//  SYReadTopTwoCell.m
//  RelaxTime
//
//  Created by imac on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadTopTwoCell.h"

#import "SYReadTopTwoModel.h"

@interface SYReadTopTwoCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation SYReadTopTwoCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

-(void)setModel:(SYReadTopTwoModel *)model{
    
    _model = model;
    self.titleLabel.text = model.title;
    
    self.authorLabel.text = model.author;
    
    self.contentLabel.text = model.introduction;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
