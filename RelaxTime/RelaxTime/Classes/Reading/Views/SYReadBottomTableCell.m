//
//  SYReadBottomTableCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadBottomTableCell.h"

#import "SYReadQuesModel.h"
#import "SYReadEssayModel.h"
#import "SYReadSeriesModel.h"

@interface SYReadBottomTableCell()
//标题label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//作者label
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
//内容label
@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
//种类图片

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

/**
 *  显示连载数据
 */
@property(nonatomic ,strong) SYReadSeriesModel * seriesModel;
/**
 *  显示短篇数据
 */
@property(nonatomic ,strong) SYReadEssayModel * essayModel;
/**
 *  显示问答数据
 */
@property(nonatomic ,strong) SYReadQuesModel * quesModel;
@end
@implementation SYReadBottomTableCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.cornerRadius = 5;
    self.typeLabel.layer.borderColor = GlobalColorBLUE.CGColor;
    self.typeLabel.layer.borderWidth = 1;
    self.backgroundColor = GlobalColor245;
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = GlobalColorBLUE.CGColor;
   
}

//wd music_comment   lz tagicon
#pragma mark - 模型赋值
-(void)setModel:(id)model{
    _model = model;
    
    //判断哪种模型
    if ([model isKindOfClass:[SYReadQuesModel class]]) {
        self.quesModel = model;
    }else if ([model isKindOfClass:[SYReadSeriesModel class]]){
        self.seriesModel = model;
    }else if ([model isKindOfClass:[SYReadEssayModel class]]){
        self.essayModel = model;
    }
}

-(void)setFrame:(CGRect)frame{
    frame.size.height = frame.size.height - 2;
    [super setFrame:frame];
}

//问题模型赋值
-(void)setQuesModel:(SYReadQuesModel *)quesModel{
    _quesModel = quesModel;
    ;
    self.typeLabel.text = @"问题";
    self.titleLabel.text= quesModel.question_title;
    self.authorLabel.text = quesModel.answer_title;
    self.contenLabel.text =quesModel.answer_content;
    
}

//短文模型赋值
-(void)setEssayModel:(SYReadEssayModel *)essayModel{

    _essayModel = essayModel;

    self.typeLabel.text = @"短文";
    self.titleLabel.text= essayModel.hp_title;
    //取出作者模型

    SYReadEssayAuthor * author = essayModel.author[0];
    self.authorLabel.text = author.user_name;
    self.contenLabel.text = essayModel.guide_word;
}

//系列模型赋值
-(void)setSeriesModel:(SYReadSeriesModel *)seriesModel{
    
    _seriesModel = seriesModel;
   
    self.typeLabel.text = @"连载";
    self.titleLabel.text= seriesModel.title;
    //取出作者模型
    SYReadSeriousAuthor * author = seriesModel.author;
    //NSLog(@"%@",author);
    self.authorLabel.text = author.user_name;
    
    self.contenLabel.text = seriesModel.excerpt;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
