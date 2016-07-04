//
//  SYReadContentView.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadContentView.h"
#import "SYReadQuesModel.h"
#import "SYReadEssayModel.h"
#import "SYReadSeriesModel.h"


@interface SYReadContentView()

@property (weak, nonatomic) IBOutlet UIImageView *iconLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;



//模型属性
@property(nonatomic ,strong) SYReadQuesModel * quesModel;
@property(nonatomic ,strong) SYReadEssayModel * essayModel;
@property(nonatomic ,strong) SYReadSeriesModel * serialModel;

@end

@implementation SYReadContentView

#pragma mark - 模型赋值


-(void)awakeFromNib{
    
    

}

//问题模型赋值
-(void)setQuesModel:(SYReadQuesModel *)quesModel{
    _quesModel = quesModel;
    
    self.titlelabel.text = quesModel.question_title;
    self.contentlabel.text =[NSString stringWithFormat:@"%@\n\n%@\n\n%@",quesModel.question_content,quesModel.answer_title,quesModel.answer_content];
      self.frame = CGRectMake(0, 0, WIDTH, _quesModel.contentViewHeight);
}
//短文模型赋值
-(void)setEssayModel:(SYReadEssayModel *)essayModel{
    _essayModel = essayModel;
    
    SYReadEssayAuthor *author = essayModel.author[0];
    [self.iconLabel sd_setImageWithURL:[NSURL URLWithString:author.web_url] placeholderImage:[UIImage imageNamed:@"default"]];
    
    self.titlelabel.text= essayModel.hp_title;
    
    self.nameLabel.text = author.user_name;
    self.contentlabel.text = essayModel.hp_content;
    self.frame = CGRectMake(0, 0, WIDTH, _essayModel.contentViewHeight);
   
    
}
//系列模型赋值
-(void)setSerialModel:(SYReadSeriesModel *)serialModel{

    _serialModel = serialModel;
    
    SYReadSeriousAuthor *author = serialModel.author;
    [self.iconLabel sd_setImageWithURL:[NSURL URLWithString:author.web_url] placeholderImage:[UIImage imageNamed:@"default"]];
    
    self.titlelabel.text= serialModel.title;
    
    self.nameLabel.text = author.user_name;
    
    self.contentlabel.text = serialModel.content;
    
      self.frame = CGRectMake(0, 0, WIDTH, _serialModel.contentViewHeight);
}
-(void)setModel:(id)model{
    
    if ([model isKindOfClass:[SYReadSeriesModel class]]) {
        [self setSerialModel:model];
    }else if ([model isKindOfClass:[SYReadEssayModel class]]){
        [self setEssayModel:model];
    }else{
        [self setQuesModel:model];
    }


}
// 10 50 20  
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
