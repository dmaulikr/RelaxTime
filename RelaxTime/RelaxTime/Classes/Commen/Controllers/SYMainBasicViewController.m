//
//  SYMainBasicViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMainBasicViewController.h"

@interface SYMainBasicViewController ()

@end

@implementation SYMainBasicViewController


-(void)dealloc{
    
    [self.requestManager.operationQueue cancelAllOperations];
    
    [[SDWebImageManager sharedManager]cancelAll];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GlobalColor245;
   
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 懒加载
//AF-manager
-(AFHTTPSessionManager *)requestManager{
    
    if (_requestManager==nil) {
        _requestManager=[AFHTTPSessionManager manager];
        
        // 设置JSON数据序列化，将JSON数据转换为字典或者数组
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 在序列化器中追加一个类型，text/html这个类型是不支持的，text/json, application/json
        _requestManager.responseSerializer.acceptableContentTypes = [_requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    
    return _requestManager;
    
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
