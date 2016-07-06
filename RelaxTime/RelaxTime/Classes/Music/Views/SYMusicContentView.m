//
//  SYMusicContentView.m
//  RelaxTime
//
//  Created by imac on 16/7/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMusicContentView.h"
#import "SYSegmentController.h"
#import "SYMusicModel.h"


@interface SYMusicContentView()

@property (weak, nonatomic) IBOutlet UIImageView *bigimagView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
//作者名字
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
//描述
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
//歌名
@property (weak, nonatomic) IBOutlet UILabel *musicName;
//信息label
@property (weak, nonatomic) IBOutlet UITextView *musicStory;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

//分段选择器
@property(nonatomic ,strong) SYSegmentController * segment;

//放置分段选择器的view
@property (weak, nonatomic) IBOutlet UIView *segmentPlaceView;


@end


@implementation SYMusicContentView


-(void)awakeFromNib{
    //创建segment
    _segment = [[SYSegmentController alloc]initWithItems:@[@"音乐故事",@"歌词", @"歌曲信息"]];
    _segment.titleColor = GlobalColorBLUE;
    [_segment addTarget:self action:@selector(btnClick:)];
    
    //给按钮的selected增加观察者
    [self.playButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
  

}

//按钮状态改变 改变动画
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
   // NSLog(@"%@",[change[@"new"]class]);
    
    if ([change[@"new"]boolValue] == YES) {
        // 初始化的时候就给定动画类型
        CABasicAnimation *ban3 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        ban3.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        // CATransform3DIdentity是单位矩阵，没有缩放，旋转，平移等改动，都是初始值
        ban3.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
        
        ban3.duration = 0.8;
        // 动画效果是否累计，下一次的动画是否以上一次动画结束为开始
        ban3.cumulative = YES;
        // 重复次数
        ban3.repeatCount = MAXFLOAT;
        
        [self.playButton.layer addAnimation:ban3 forKey:nil];

    }else{
        
        [self.playButton.layer removeAllAnimations];
    
    }
    
}

#pragma mark - 模型赋值
-(void)setModel:(SYMusicModel *)model{
    _model = model;
    //背景图
    [_bigimagView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default"]];
    
    //头像
    SYMusicAuthor * author = model.author;
    [_smallImageView sd_setImageWithURL:[NSURL URLWithString:author.web_url] placeholderImage:[UIImage imageNamed:@"default"]];
    
    //名字
    _musicName.text = model.title;
    
    //作者名字
    _authorLabel.text = author.user_name;
    //描述
    _subjectLabel.text =  author.desc;
    
  
    //设置下方故事label的文字 设置自身的frame
    
    //根据segment的Selected赋值
    
    [self btnClick:_segment];
    
}



#pragma mark - segment点击事件
-(void)btnClick:(SYSegmentController *)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:
            _musicStory.text = _model.story;
            
            self.frame = CGRectMake(0, 0, WIDTH, _model.musicStroyTextHeight);
            break;
        case 1:
            _musicStory.text = _model.lyric;
            
            self.frame = CGRectMake(0, 0, WIDTH, _model.lyrHeight);
            break;
        case 2:
            _musicStory.text = _model.info;
            
            self.frame = CGRectMake(0, 0, WIDTH, _model.infoHeigt);
            break;
        default:
            break;
    }
    
    //调用代理方法 刷新界面
    [self.delegate contentViewHasBeenChanged:self];
    
}

#pragma mark - 播放按钮点击事件
- (IBAction)playButton:(id)sender {
    
    [self.delegate playButtonClick:self.playButton];
    
}
#pragma mark - 换歌按钮
- (IBAction)changgeBtn:(id)sender {
    
    [self.delegate changeBunttonClick:self.changeButton];
}


-(void)layoutSubviews{
    //设置segment大小
    _segment.frame = CGRectMake(20, 0, WIDTH - 40, 44);
    [self.segmentPlaceView addSubview:_segment];
}

-(void)dealloc{
    
    //移除观察者
    [self.playButton removeObserver:self forKeyPath:@"selected"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
