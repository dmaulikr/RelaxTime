//
//  SYMainBasicViewController.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

/**
 *  所有viewVC父类
 */
#import <UIKit/UIKit.h>

@interface SYMainBasicViewController : UIViewController

@property(nonatomic ,strong)  AFHTTPSessionManager* requestManager;

@property(nonatomic ,strong) NSMutableArray * dataArray;
@end
