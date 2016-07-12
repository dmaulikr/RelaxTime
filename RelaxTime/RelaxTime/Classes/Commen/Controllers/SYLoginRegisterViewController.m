//
//  SYLoginRegisterViewController.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//
#import "SYLoginRegisterViewController.h"
#import "SYTextField.h"
#import "SYSecretController.h"

@interface SYLoginRegisterViewController ()

// 登录框距离控制器view左边的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
//改变
@property (weak, nonatomic) IBOutlet UIButton *changButton;

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

//验证码
@property (weak, nonatomic) IBOutlet SYTextField *registerSecret;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *smsButton;


@end

@implementation SYLoginRegisterViewController

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self set];
    
}

#pragma mark - 初始化
-(void)set{
    
    //注册按钮不可用
    self.registerBtn.enabled = NO;
}


#pragma mark - 登录按钮
- (IBAction)logBtn:(UIButton *)sender {
    SYLog(@"登录");
    
    // ----判断手机号码格式位数是否正确
    if (![self phoneNumberStyle:self.loginPhone.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不正确"];
        return;
    }
    
    //判断登录密码正确与否
    [self.view endEditing:YES];
    
    AVQuery *query = [AVQuery queryWithClassName:@"user"];
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD showWithStatus:@"登录中~"];
    self.view.userInteractionEnabled = NO;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        SYLog(@"%@", objects);
        for (AVObject *todo in objects) {
            
            if ([[todo valueForKey:@"phoneNumber"] isEqualToString:weakSelf.loginPhone.text] && [[todo valueForKey:@"password"] isEqualToString:weakSelf.loginSecret.text]) {
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                //把信息写在本地
                [self localMessage];
                
                [self.delegate changeUser];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
             }
            }
        [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
          weakSelf.view.userInteractionEnabled = YES;
        }];

    

    // 退出键盘
    [self.view endEditing:YES];
}

#pragma mark - 手机号码登录信息本地化
-(void)localMessage{
  
       // [[NSUserDefaults standardUserDefaults]setObject:self.loginSecret.text forKey:@"userSecret"];
    //重置
       [NSUserDefaults resetStandardUserDefaults];
    
      [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"registerByPhone"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]setObject:self.loginPhone.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userIcon"];
   

}

#pragma mark - 忘记密码
- (IBAction)forget:(id)sender {
    SYLog(@"忘记密码");
}

#pragma mark - 验证码发送
- (IBAction)smsButton:(id)sender {
    // ----判断手机号码格式位数是否正确
    if (![self phoneNumberStyle:self.registerPhone.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不正确"];
        return;
    }
    
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"发送验证中"];
    self.view.userInteractionEnabled = NO;
    
    // ----判断手机号是否已经注册
    AVQuery *query = [AVQuery queryWithClassName:@"user"];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (AVObject *todo in objects) {
            
            if ([[todo valueForKey:@"phoneNumber"] isEqualToString:weakSelf.registerPhone.text] ) {
                [SVProgressHUD showInfoWithStatus:@"该手机号已注册"];
                 weakSelf.view.userInteractionEnabled = YES;
                return ;
            }
        }
       // 如果没有注册 发送发送验证码
        [AVOSCloud requestSmsCodeWithPhoneNumber:self.registerPhone.text
                                         appName:@"[闲Time]"
                                       operation:@"注册验证"
                                      timeToLive:10
                                        callback:^(BOOL succeeded, NSError *error) {
                                            if (succeeded) {
                                                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
                                                //开启注册用户响应
                                                weakSelf.registerBtn.enabled = YES;
                                        //关闭发送验证码按钮响应
                                                self.smsButton.userInteractionEnabled=NO;
                                        //计时开始
                                                [self countDown];
                                        
                                            }else{
                                                NSLog(@"%@",error);
                                                [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
                                            }
                                              weakSelf.view.userInteractionEnabled = YES;
                                        }];
        
        
    }];
     
}

#pragma mark - 验证码60s倒计时
- (void) countDown {
    
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局队列
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);//定时器
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行一次
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                weakSelf.smsButton.userInteractionEnabled = YES;
            });
        } else {
            
            
            NSString *strTime = [NSString stringWithFormat:@"%d秒后重新获取验证码", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.smsButton setTitle:strTime forState:UIControlStateNormal];
                weakSelf.smsButton.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}



#pragma mark - 快速登录

- (IBAction)fastLogin:(UIButton *)sender {
    SYLog(@"快速登录");
    
    //判断有没有QQ
    
    __weak typeof (self) weakSelf = self;
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSQQ]) {
        // __weak typeof(self) weakSelf = self;
        [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:QQAppID andAppSecret:QQAppKey andRedirectURI:@""];
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                
                SYLog(@"%@", error.localizedDescription);
            } else {
                //重置
                [NSUserDefaults resetStandardUserDefaults];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"registerByPhone"];
                [[NSUserDefaults standardUserDefaults] setValue:object[@"username"] forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setValue:object[@"avatar"] forKey:@"userIcon"];
                
                //代理方法改变头像
                [weakSelf.delegate changeUser];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        } toPlatform:AVOSCloudSNSQQ];
    }else{
        [SVProgressHUD showInfoWithStatus:@"当前设备未安装QQ"];
    }
    
   

}

#pragma mark - 注册按钮
- (IBAction)register:(UIButton *)sender {
    
    // ----判断手机号码格式位数是否正确
    if (![self phoneNumberStyle:self.registerPhone.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不正确"];
        return;
    }
   
  
    __weak typeof(self) weakSelf = self;
    
     [SVProgressHUD showWithStatus:@"注册中"];
    
      self.view.userInteractionEnabled = NO;
    //判断验证码是否输入正确
   
    
    [AVOSCloud verifySmsCode:self.registerSecret.text mobilePhoneNumber:self.registerPhone.text callback:^(BOOL succeeded, NSError *error) {
        
         self.view.userInteractionEnabled = YES;
            //验证成功
            //弹出输密码框
           if(succeeded){
                SYLog(@"注册成功");
           
            SYSecretController *secretVC = [[SYSecretController alloc]init];
             
            secretVC.phoneNumber = self.registerPhone.text;
            
             [secretVC setBlock:^{
                 [weakSelf showLoginOrRegister:self.changButton];
                 weakSelf.loginPhone.text = self.registerPhone.text;
                 weakSelf.loginSecret.text =@"";
                 weakSelf.registerPhone.text =@"";
                 weakSelf.registerSecret.text =@"";
             }];
               
            [weakSelf presentViewController:secretVC animated:YES completion:nil];
                   
           }else{
               
               [SVProgressHUD showErrorWithStatus:@"验证码验证失败"];
               
           }
            
    }];

}

#pragma mark - 判断手机号码格式
- (BOOL) phoneNumberStyle:(NSString *) phoneNumber {
    
    
    if (phoneNumber.length == 11) return YES;
    return NO;
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
