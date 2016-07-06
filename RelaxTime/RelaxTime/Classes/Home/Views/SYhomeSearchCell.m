//
//  SYhomeSearchCell.m
//  RelaxTime
//
//  Created by imac on 16/7/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYhomeSearchCell.h"
#import "SYHomeModel.h"

@interface SYhomeSearchCell()

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation SYhomeSearchCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(SYHomeModel *)model{

    _model =model;
    
    self.label1.text = model.hp_author;
    self.label2.text = model.hp_content;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.hp_img_original_url] placeholderImage:[UIImage imageNamed:@"default"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
