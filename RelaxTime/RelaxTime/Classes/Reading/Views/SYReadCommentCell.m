//
//  SYReadCommentCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadCommentCell.h"

@interface SYReadCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *icomView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SYReadCommentCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModel:(SYReadCommentModel *)model{

    _model = model;
    
    SYReadCommentUser *user = _model.user;
    
    [self.icomView sd_setImageWithURL:[NSURL URLWithString:user.web_url] placeholderImage:[UIImage imageNamed:@"default"]];
    
    self.nameLabel.text = user.user_name;
    
    self.dateLable.text = model.input_date;
    
    self.contentLabel.text =model.content;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
