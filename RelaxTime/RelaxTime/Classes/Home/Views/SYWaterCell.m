//
//  SYWaterCell.m
//  RelaxTime
//
//  Created by imac on 16/6/30.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYWaterCell.h"

@interface SYWaterCell()
@property (weak, nonatomic) IBOutlet UIImageView *iamgeVIew;

@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation SYWaterCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
  
   // self.backgroundColor = CellGlobalColor;
    self.backgroundColor = SYColorRBG(140, 140, 140);
}


-(void)setModel:(SYHomeModel *)model{

    _model = model;
    
    [self.iamgeVIew sd_setImageWithURL:[NSURL URLWithString:model.hp_img_original_url] placeholderImage:[UIImage imageNamed:@"default"]];
    
    self.label.text = model.hp_content;
    
   
}
@end
