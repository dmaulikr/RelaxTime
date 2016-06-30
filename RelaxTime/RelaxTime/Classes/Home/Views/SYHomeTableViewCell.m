//
//  SYHomeTableViewCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeTableViewCell.h"
#import "SYHomeModel.h"

@interface SYHomeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorlabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation SYHomeTableViewCell

- (void)awakeFromNib {
     //Initialization code
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.clipsToBounds = YES;
    SYLogFunc;
   
}

-(void)setModel:(SYHomeModel *)model{
    
    _model = model;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.hp_img_original_url] placeholderImage:nil];
    self.contentLabel.text = model.hp_content;
    self.authorlabel.text = model.hp_author;
    self.dateLabel.text = model.last_update_date;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
