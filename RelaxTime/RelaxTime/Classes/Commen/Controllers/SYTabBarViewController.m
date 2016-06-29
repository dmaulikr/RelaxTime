//
//  SYTabBarViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYTabBarViewController.h"
#import "SYMovieViewController.h"
#import "SYMusicViewController.h"
#import "SYHomeViewController.h"
#import "SYReadViewController.h"
#import "SYNavgationController.h"

@interface SYTabBarViewController ()

@end

@implementation SYTabBarViewController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = GlobalBlueColor;
    ;
    
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = SYColorRBG(85, 150, 250);
    
    //设置选中前后颜色
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加子控制器
    [self setupChildVc:[[SYHomeViewController alloc] init] title:@"首页" image:@"tabBarHome" selectedImage:@"tabBarHome_selected"];
    
    [self setupChildVc:[[SYReadViewController alloc] init] title:@"文章" image:@"tabBarRead" selectedImage:@"tabBarRead_selected"];
    
    [self setupChildVc:[[SYMusicViewController alloc] init] title:@"音乐" image:@"tabBarMusic" selectedImage:@"tabBarMusic_selected"];
    
    [self setupChildVc:[[SYMovieViewController alloc] init] title:@"电影" image:@"tabBarMovie" selectedImage:@"tabBarMovie_selected"];
    
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
     SYNavgationController*nav = [[SYNavgationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
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
