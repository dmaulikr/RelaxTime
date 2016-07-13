//
//  SYLuanchController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/13.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYLuanchController.h"
#import "SYPageControl.h"
#import "UIImage+animatedGIF.h"
#import "SYTabBarViewController.h"


#define launchButtonX  ((WIDTH - launchButtonW)/2)

#define launchButtonY  (HEIGHT - 10 - launchButtonH)

#define launchButtonW  200

#define launchButtonH  40

@interface SYLuanchController ()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SYPageControl *pageControl;
@property(nonatomic ,strong) UIButton * button;

@end





@implementation SYLuanchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
    
}
-(void)creatUI{
    self.scrollView.contentSize = CGSizeMake(WIDTH * 4, HEIGHT);
    //获取gif文件路径
    
    NSArray *gifArray= @[@"Gif1",@"Gif2",@"Gif3",@"Gif4"];
    NSArray *textArray = @[@"闲", @"来", @"无", @"事"];
   
    int i = 0;
    for (NSString * gifName in gifArray) {
        //将本地路径转为NSURL类型
        
        //加图片
        NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        
        NSURL *url = [NSURL fileURLWithPath:path];
        UIImage *image1 = [UIImage animatedImageWithAnimatedGIFURL:url];
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        imageView1.image = image1;
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
   
        [self.scrollView addSubview:imageView1];
        
        //加label
        CGFloat labelW = WIDTH / 3;
        CGFloat labelH = labelW;
        CGFloat labelX = (WIDTH - labelW)/2;
        CGFloat labelY = HEIGHT / 4;
       
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
     //富文本
        NSMutableDictionary *attri = [NSMutableDictionary dictionary];
        attri[NSFontAttributeName] = [UIFont fontWithName:@"Tensentype-XiChaoHeiJ" size:80];
        attri[NSForegroundColorAttributeName] = SYColorRGB(232, 126, 162);
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:textArray[i] attributes:attri];
        label.attributedText= attriStr;
        
        [imageView1 addSubview:label];
        
        i++;
    }
   
//        NSArray *fontFamilies = [UIFont familyNames];
//        for (int i = 0; i < [fontFamilies count]; i++)
//        {
//            NSString *fontFamily = [fontFamilies objectAtIndex:i];
//            NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//            SYLog (@"%@: %@", fontFamily, fontNames);
//        }
    
  //button
       self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
        CGFloat buttonX = launchButtonX;
        CGFloat buttonY = launchButtonY + 60;
        CGFloat buttonH = launchButtonH;
        CGFloat buttonW = launchButtonW;
         self.button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    
        [ self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
       self.button.backgroundColor= SYColorRGB(232, 126, 162);
       self.button.layer.cornerRadius = 20;
        self.button.layer.borderColor = [UIColor whiteColor].CGColor;
       [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       self.button.userInteractionEnabled = NO;
    
      [self.view addSubview: self.button];
 
    //富文本
    NSMutableDictionary *attrib = [NSMutableDictionary dictionary];
     attrib[NSFontAttributeName] = [UIFont fontWithName:@"Tensentype-XiChaoHeiJ" size:20];
     attrib[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    NSMutableAttributedString *attriStrb = [[NSMutableAttributedString alloc] initWithString:@"点击进入闲Time" attributes:attrib];

    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    labelB.backgroundColor = [UIColor clearColor];
    labelB.textAlignment = NSTextAlignmentCenter;
    labelB.attributedText = attriStrb;
    [self.button addSubview:labelB];
    
    
    
    
}

-(void)buttonClick{
    
    SYTabBarViewController * tabBar = [[SYTabBarViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    self.pageControl.currentPage = (NSInteger)round(scrollView.contentOffset.x / WIDTH);
    self.button.userInteractionEnabled = NO;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 
    [self dismissButton];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //如果不减速了
    if (!decelerate) {
        SYLogFunc;
        
        //判断如果是最后一张 显示按钮
        if (round(scrollView.contentOffset.x /WIDTH) == 3) {
            [self showButton];
        }
    }
    //如果还要减速 交给scrollViewDidEndDecelerating 处理
   
   
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //将减速完成 判断是不是最后一张 显示按钮
    if (scrollView.contentOffset.x /WIDTH == 3) {
        [self showButton];
    }
}



-(void)showButton{
    
    self.button.userInteractionEnabled = YES;
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
        CGFloat buttonX = launchButtonX;
        CGFloat buttonY = launchButtonY;
        CGFloat buttonH = launchButtonH;
        CGFloat buttonW = launchButtonW;
        
        weakSelf.button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }];

}

-(void)dismissButton{
    
    self.button.userInteractionEnabled = NO;
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
        CGFloat buttonX = launchButtonX;
        CGFloat buttonY = launchButtonY + 60;
        CGFloat buttonH = launchButtonH ;
        CGFloat buttonW = launchButtonW;
        
        weakSelf.button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
