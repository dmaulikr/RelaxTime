//
//  SYMovieViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieViewController.h"
#import "SYSegmentController.h"
@interface SYMovieViewController ()

@end

@implementation SYMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SYSegmentController * segment = [[SYSegmentController alloc]initWithItems:@[@"音乐故事",@"歌词", @"歌曲信息"]];
    [segment addTarget:self action:@selector(btnClick:)];
    
    segment.frame = CGRectMake( 0, 100, WIDTH, 50);
    
    [self.view addSubview:segment];
  
}

-(void)btnClick:(SYSegmentController *)seg{

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
