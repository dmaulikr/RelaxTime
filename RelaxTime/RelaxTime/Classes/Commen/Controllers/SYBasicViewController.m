//
//  SYBasicViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYBasicViewController.h"

@interface SYBasicViewController ()

@end

@implementation SYBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航栏左边的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_seach" highImage:@"nav_seach" target:self action:@selector(searchClick)];
    
    // 设置导航栏右边边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"userSet" highImage:@"userSet" target:self action:@selector(userClick)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - 按钮点击事件
//搜索
-(void)searchClick{

}
//用户
-(void)userClick{

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
