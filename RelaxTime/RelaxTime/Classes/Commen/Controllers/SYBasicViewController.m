//
//  SYBasicViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYBasicViewController.h"
#import "SYSetController.h"

@interface SYBasicViewController ()

@end

@implementation SYBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_seach" highImage:@"nav_seach" target:self action:@selector(searchClick)];
    
    // 设置导航栏右边边的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"userSet" highImage:@"userSet" target:self action:@selector(userClick)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


-(void)setTitleViewWithText:(NSString *)text{
    //标题
    NSMutableDictionary *attrib = [NSMutableDictionary dictionary];
    attrib[NSFontAttributeName] = [UIFont fontWithName:@"Tensentype-XiChaoHeiJ" size:20];
    attrib[NSForegroundColorAttributeName] = SYColorRGB(232, 126, 162);
    
    NSMutableAttributedString *attriStrb = [[NSMutableAttributedString alloc] initWithString:text attributes:attrib];
    
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    labelB.backgroundColor = [UIColor clearColor];
    labelB.textAlignment = NSTextAlignmentCenter;
    labelB.attributedText = attriStrb;
    self.navigationItem.titleView = labelB;
}

#pragma mark - 按钮点击事件
//搜索
-(void)searchClick{

}
//用户
-(void)userClick{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SYSetController *setVC = [sb instantiateViewControllerWithIdentifier:@"SYSetController"];
    setVC.title = @"设置";
    
    [self.navigationController pushViewController:setVC animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
