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

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation SYHomeTableViewCell

- (void)awakeFromNib {
     //Initialization code
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1;
    self.layer.borderColor = GlobalColorBLUE.CGColor;
    //self.clipsToBounds = YES;

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
    
    //[SVProgressHUD showErrorWithStatus:@"敬请期待哦"];
    
    id vc =  [UIApplication sharedApplication].keyWindow.rootViewController;
   
    /**
     *  友盟简单版
     */
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_model.hp_img_original_url];
//    [UMSocialData defaultData].extConfig.title = @"[闲Time]语录";
//    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
//    
//    [UMSocialSnsService presentSnsIconSheetView:vc
//                                         appKey:UMAppKey
//                                      shareText:_model.hp_content
//                                     shareImage:[UIImage imageNamed:@"icon"]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ]
//                                       delegate:vc];
    
    
    /**
     * 系统简单粗暴直接版 可以自己自定义UI按钮弹出(自带的支持的只有新浪微博)  可以加在UIActivityViewController的自定义activity上弹出
     */
//    SLComposeViewController *svc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//    SLComposeViewControllerCompletionHandler myblock = ^(SLComposeViewControllerResult result){
//        if(result == SLComposeViewControllerResultCancelled){
//            SYLog(@"cancel");
//        }else{
//            SYLog(@"done");
//        }
//        [svc dismissViewControllerAnimated:YES completion:nil];
//    };
//    svc.completionHandler = myblock;
//    //设置预留文字
//    [svc setInitialText:_model.hp_content];
//    //设置预留图片
//    [svc addImage:_picImageView.image];
//    //设置链接
//    [svc addURL: [NSURL URLWithString:@"http://www.baidu.com"]];
//    [vc presentViewController:svc animated:YES completion:nil];
    
    
    /**
     *  系统自带
     */
    NSString *textToShare =@"[闲Time]语录" ;
    
    NSString *description = _model.hp_content;
    
    UIImage *imageToShare = _picImageView.image;
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.Xtime.com"];
    
    NSArray *activityItems = @[textToShare, description,imageToShare, urlToShare];
    
    //创建自定义的Activity，加到一个数组里边
    
//    SYCustomActivity *act1 = [[SYCustomActivity alloc]initWithImage:[UIImage imageNamed:@"longLu"] atURL:@"http://www.iashes.com/" atTitle:@"share Sina" atShareContentArray:activityItems];
//    
//    //myActivity是自定义的类，继承于UIActivity
//    
//    SYCustomActivity *act2 = [[SYCustomActivity alloc]initWithImage:[UIImage imageNamed:@"cat"] atURL:@"http://www.iashes.com/admin.html" atTitle:@"share Renren" atShareContentArray:activityItems];
    
    //NSArray *apps = @[act1,act2];
    
    //创建
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    //关闭系统的一些分享
    activityVC.excludedActivityTypes = @[UIActivityTypePostToTwitter,
                                         UIActivityTypeMessage,
                                         
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         
                                         UIActivityTypeSaveToCameraRoll,
                                         
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    //模态
    
    [vc presentViewController:activityVC animated:YES completion:nil];
  
}


- (IBAction)likeBtn:(id)sender {
    
    //改变模型数据
    _model.isLike = !_model.isLike;
    
    //加入数据库
    if (_model.isLike) {
        [[BasicDataManager manager]insertDataWithModel:_model];
    }else{
        [[BasicDataManager manager]deleteDataWithContentId:_model.hpcontent_id];
    }


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

    //判断有没有搜藏过
    self.likeBtn.selected = [[BasicDataManager manager]checkIsInDBWithhpContentId:model.hpcontent_id];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
