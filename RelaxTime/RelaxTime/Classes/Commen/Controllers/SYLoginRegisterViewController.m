//
//  SYLoginRegisterViewController.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//
#import "SYLoginRegisterViewController.h"
#import "SYTextField.h"

@interface SYLoginRegisterViewController ()

// 登录框距离控制器view左边的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

/**
 *  登录
 */
//登录手机号
@property (weak, nonatomic) IBOutlet SYTextField *loginPhone;
//登录密码
@property (weak, nonatomic) IBOutlet SYTextField *loginSecret;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/**
 *  注册
 */

@property (weak, nonatomic) IBOutlet SYTextField *registerPhone;

@property (weak, nonatomic) IBOutlet SYTextField *registerSecret;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation SYLoginRegisterViewController

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - 登录按钮
- (IBAction)logBtn:(UIButton *)sender {
    SYLog(@"登录");
    // 退出键盘
    [self.view endEditing:YES];
}
#pragma mark - 忘记密码
- (IBAction)forget:(id)sender {
    SYLog(@"忘记密码");
}

#pragma mark - 快速登录

- (IBAction)fastLogin:(UIButton *)sender {
    SYLog(@"快速登录");
    
    
   // __weak typeof(self) weakSelf = self;
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:QQAppID andAppSecret:QQAppKey andRedirectURI:@""];
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            
            SYLog(@"%@", error.localizedDescription);
        } else {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            
            [[NSUserDefaults standardUserDefaults] setValue:object[@"username"] forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setValue:object[@"avatar"] forKey:@"userIcon"];
            
            //代理方法改变头像
            [self.delegate changeUser];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } toPlatform:AVOSCloudSNSQQ];

}

#pragma mark - 注册按钮

- (IBAction)register:(UIButton *)sender {
    
    SYLog(@"注册");
}


- (IBAction)showLoginOrRegister:(UIButton *)button {
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) { // 显示注册界面
        self.loginViewLeftMargin.constant = - self.view.width;
        button.selected = YES;
    } else { // 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
