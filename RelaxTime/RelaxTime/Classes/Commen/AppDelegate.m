//
//  AppDelegate.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "AppDelegate.h"
#import "SYTabBarViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "SYLuanchController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册UM
    [UMSocialData setAppKey:UMAppKey];
    
    [self setUM];
    
    
    // ----注册LeanCloud
    [AVOSCloud setApplicationId:AVCloudAppId
                      clientKey:AVCloudAppKey];
    
    
    /*=========    ======*/
    [self setRootController];
    
   
    //设置显示时间
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    return YES;
}

-(void)setRootController{
    
   
    NSString *key = @"CFBundleShortVersionString";
    
    // 1.从plist中取出版本号
    
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号

    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    SYLog(@"当前版本号======== %@", saveVersion);
    
    if([version isEqualToString:saveVersion]) {
        
        //不是第一次使用这个
        SYTabBarViewController * tabBar = [[SYTabBarViewController alloc]init];
        self.window.rootViewController = tabBar;
       
        
    }else{
        
        //版本号不一样：第一次使用新版本
        
        //将新版本号写入沙盒
        SYLuanchController *launchVc = [[SYLuanchController alloc]init];
        self.window.rootViewController = launchVc;
        
#if(1)
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
#endif
        
  }
}

-(void)setUM{
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:@"http://www.baidu.com"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
   
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
  
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppID
                                              secret:SinaAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

}


// When Build with IOS 9 SDK
// For application on system below ios 9
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
//    SYLog(@"!!!!!!%@",sourceApplication);
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
        return [AVOSCloudSNS handleOpenURL:url];
    }
    return result;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [AVOSCloudSNS handleOpenURL:url];
}

// For application on system equals or larger ios 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [AVOSCloudSNS handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
