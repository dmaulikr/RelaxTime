//
//  SYMovieContentView.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/7.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieContentView.h"
#import "SYMovieDetailModel.h"
#import "SYMovieStoryModel.h"
#import "SYMoviePicCell.h"

@interface SYMovieContentView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//两个模型
@property(nonatomic ,strong) SYMovieDetailModel * detailModel;
@property(nonatomic ,strong) SYMovieStoryModel * storyModel;

/**上方数据*/
//上方图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//故事头像
@property (weak, nonatomic) IBOutlet UIImageView *storyIcon;
//故事作者
@property (weak, nonatomic) IBOutlet UILabel *storyAuthor;
//故事标题
@property (weak, nonatomic) IBOutlet UILabel *storyTitle;

//故事内容
@property (weak, nonatomic) IBOutlet UILabel *storyContent;

/**下方数据*/

//指示文字
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//评论显示的button
@property (weak, nonatomic) IBOutlet UIButton *buttonFirst;
//剧照的button
@property (weak, nonatomic) IBOutlet UIButton *buttonSecond;
//剧组的button
@property (weak, nonatomic) IBOutlet UIButton *buttonThird;

/**显示评论的View*/
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UILabel *label5;

/**显示剧照的的collectionView*/

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic ,strong) NSMutableArray * dataArray;

/**显示电影信息的的label*/
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end


@implementation SYMovieContentView


-(void)awakeFromNib{
    //设置样式
    self.commentView.backgroundColor = [UIColor whiteColor];
    self.commentView.layer.borderColor = GlobalColorBLUE.CGColor;
    self.commentView.layer.borderWidth = 2;
    self.label1.layer.borderWidth = 0.5;
    self.label1.layer.borderColor = GlobalColorBLUE.CGColor;
    self.label2.layer.borderWidth = 0.5;
    self.label2.layer.borderColor = GlobalColorBLUE.CGColor;
    self.label3.layer.borderWidth = 0.5;
    self.label3.layer.borderColor = GlobalColorBLUE.CGColor;
    self.label4.layer.borderWidth = 0.5;
    self.label4.layer.borderColor = GlobalColorBLUE.CGColor;
    self.label5.layer.borderWidth = 0.5;
    self.label5.layer.borderColor = GlobalColorBLUE.CGColor;
    
    //collectionView
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SYMoviePicCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    //默认选中
    self.commentView.hidden = NO;
    self.collectionView.hidden = YES;
    self.infoLabel.hidden = YES;
    
    self.buttonFirst.selected = YES;
    
    //大小 xib各部分相加
    CGFloat selfHeight = WIDTH / 2 + 15 + 22 + 15 + 30 + 10 + 40 + 10 + 20 + 30 + 20 + WIDTH /2.2;
    
    self.frame =CGRectMake(0, 0, WIDTH, selfHeight);
    
    
}

#pragma mark - 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 模型赋值 并且设定自身的高度

-(void)showMessageWithDetaiModel:(SYMovieDetailModel *)detaiModel{
  
    self.detailModel =detaiModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:detaiModel.detailcover] placeholderImage:[UIImage imageNamed:@"default"]];
    
    //关键字label
    [self setLabel1ToLabel5With:detaiModel.keywords];
    //电影信息label
    self.infoLabel.text = detaiModel.info;
    
    //collectionView数据源
    [self.dataArray addObjectsFromArray:detaiModel.photo];
    [self.collectionView reloadData];
}

-(void)setLabel1ToLabel5With:(NSString *)keyWords{
    
    NSArray *array = [keyWords componentsSeparatedByString:@";"];
    self.label1.text = array[0];
    self.label2.text =array[1];
    self.label3.text = array[2];
    self.label4.text =array[3];
    self.label5.text =array[4];
    
}
-(void)showMessageWithStoryModel:(SYMovieStoryModel *)storyModel{
    
    self.storyModel =storyModel;
    
    storyUser * user = self.storyModel.user;
    [self.storyIcon sd_setImageWithURL:[NSURL URLWithString:user.web_url] placeholderImage:[UIImage imageNamed:@"default"]];
    self.storyAuthor.text = user.user_name;
    
    self.storyTitle.text = storyModel.title;
    
    self.storyContent.text = storyModel.content;
    
    //重新计算高度
    self.height = self.height + storyModel.storyHeight;
    
    
}

#pragma mark - 按钮事件
//买票
- (IBAction)buy:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"等待开放"];
}
//评分
- (IBAction)coment:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"等待开放"];
}

//分享
- (IBAction)share:(id)sender {
    
}
//播放
- (IBAction)play:(id)sender {
    
    [self.delegate SYMovieContentViewPlayButtonClick];
    
}

//切换按钮
- (IBAction)buttonClick:(UIButton *)sender {
    
    self.buttonFirst.selected = NO;
    self.buttonSecond.selected = NO;
    self.buttonThird.selected = NO;
    
    self.commentView.hidden = YES;
    self.collectionView.hidden = YES;
    self.infoLabel.hidden = YES;
    
    sender.selected = YES;
    if (sender == self.buttonFirst) {
        self.typeLabel.text =@"电影表";
         self.commentView.hidden = NO;
        
        
    }else if(sender == self.buttonSecond){
         self.typeLabel.text =@"剧照";
        self.collectionView.hidden = NO;
    }else{
         self.typeLabel.text =@"电影信息";
         self.infoLabel.hidden = NO;
    }
}

#pragma mark - collectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SYMoviePicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.imageVIew sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    return cell;
}
//返回cell尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据xib中的数据计算
    CGFloat cellHeight = WIDTH / 2.2 - 30;
    CGFloat cellWidth = cellHeight;
    return CGSizeMake(cellWidth ,cellHeight);
    
}

//返回cell的间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//返回insert
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
