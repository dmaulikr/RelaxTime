//
//  SYSecret.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYSecretController.h"
#import "SYTextField.h"

@interface SYSecretController ()

@property (weak, nonatomic) IBOutlet SYTextField *secretOne;

@property (weak, nonatomic) IBOutlet SYTextField *secretTwo;



@end

@implementation SYSecretController


- (IBAction)done:(id)sender{
    
    [self.view endEditing:YES];
    
    if ([self.secretTwo.text isEqualToString:@""] || [self.secretTwo.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    
    if (![self.secretOne.text isEqualToString:self.secretTwo.text]) {
        [SVProgressHUD showInfoWithStatus:@"密码不一致"];
    }else{
        
        self.block();
        
        //上传密码到服务器 完成后跳转
        [self uploadUserMessage];
      
        
       
    }
    
}



- (void) uploadUserMessage {
    
    
    self.view.userInteractionEnabled = NO;
    
    AVObject *todo = [AVObject objectWithClassName:@"user"];
    [todo setObject:self.phoneNumber forKey:@"phoneNumber"];
    [todo setObject:self.secretOne.text forKey:@"password"];
    __weak typeof (self) weakSelf = self;
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [SVProgressHUD showSuccessWithStatus:@"注册完成!\n请登录"];
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"注册失败\n请重试"];
        }
        
         self.view.userInteractionEnabled = YES;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
