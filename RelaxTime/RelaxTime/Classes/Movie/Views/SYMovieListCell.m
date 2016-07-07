//
//  SYMovieListCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieListCell.h"
#import "SYMovieListModel.h"


@interface SYMovieListCell()
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation SYMovieListCell

- (void)awakeFromNib {
    // Initialization code
}


#pragma mark - cell之间的间隙
- (void)setFrame:(CGRect)frame {
        
        frame.size.height -= 5;
        [super setFrame:frame];
}


- (void)setModel:(SYMovieListModel *)model {
    
        _model = model;
    self.picView.image = [UIImage imageNamed:@"default"];
        
        // ----处理图片
    UIImageView *imageView = [[UIImageView alloc] init];
    __weak typeof(self) weakSelf = self;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //压缩图片
                NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.5);
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.picView.image = [UIImage imageWithData: imageData];
                });
            });
            
        }];
        
        //    NSArray *fontFamilies = [UIFont familyNames];
        //    for (int i = 0; i < [fontFamilies count]; i++)
        //    {
        //        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        //        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        //        SYLog (@"%@: %@", fontFamily, fontNames);
        //    }
        
        // ----处理分数
        NSMutableDictionary *attri = [NSMutableDictionary dictionary];
        attri[NSFontAttributeName] = [UIFont fontWithName:movieScoreListFont size:40];
        attri[NSForegroundColorAttributeName] = [UIColor redColor];
        attri[NSUnderlineStyleAttributeName] = @(50);
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", _model.score] attributes:attri];
    
    
        if ([_model.scoretime isEqualToString:@"显示分数"]) {
            
            _scoreLabel.attributedText = attriStr;
        } else {
            
            _scoreLabel.text= [NSString stringWithFormat:@"%@",_model.scoretime];
      
        }
    
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
