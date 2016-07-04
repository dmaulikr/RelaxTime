//
//  SYHomeTableViewCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeTableViewCell.h"
#import "SYHomeModel.h"
#import "SYShowPicViewController.h"

@interface SYHomeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorlabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//喜欢按钮
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
//喜欢数量
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation SYHomeTableViewCell

- (void)awakeFromNib {
     //Initialization code
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1;
    self.layer.borderColor = GlobalColorBLUE.CGColor;
    self.clipsToBounds = YES;
    
    self.backgroundColor =  CellGlobalColor;
    
    //self.bottomView.layer.borderColor = GlobalColorBLUE.CGColor;
  

   // SYLogFunc;
    
    //给图片添加单击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    self.picImageView.userInteractionEnabled = YES;
    [self.picImageView addGestureRecognizer:tap];
   
}



#pragma mark - 单击手势
-(void)tap{
    
    //判断图片下载完毕没
    if (_model.isDownLoadImage) {
        SYShowPicViewController *showVC = [[SYShowPicViewController alloc]init];
        showVC.image = self.picImageView.image;
        showVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showVC animated:YES completion:^{
            //
        }];
    }
    
}
#pragma mark -按钮点击事件
- (IBAction)shareBtn:(id)sender {
    
    [SVProgressHUD showErrorWithStatus:@"敬请期待哦"];
  
}

- (IBAction)likeBtn:(id)sender {
    
    //改变模型数据
    _model.isLike = !_model.isLike;
    
    //改变喜欢数量 和模型数据
    int num = [_model.praisenum intValue];
     _model.isLike ? num ++ : num --;
    _model.praisenum = [NSString stringWithFormat:@"%d",num];
    self.likeNumLabel.text = _model.praisenum;
   

    //改变按钮选中状态
    self.likeBtn.selected = _model.isLike;
}

#pragma mark - 模型赋值
-(void)setModel:(SYHomeModel *)model{
    
    _model = model;
  
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.hp_img_original_url] placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //图片已经下载成功
        _model.isDownLoadImage = YES;
    }];
    
    self.contentLabel.text = model.hp_content;
    self.authorlabel.text = model.hp_author;
    self.dateLabel.text = model.last_update_date;
    self.likeNumLabel.text= model.praisenum;
    self.likeBtn.selected = model.isLike;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
