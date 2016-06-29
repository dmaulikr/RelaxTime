//
//  SYBasicViewController.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

/**
 *  tabbar首页的viewVC父类
 */
#import <UIKit/UIKit.h>
#import "SYMainBasicViewController.h"

@interface SYBasicViewController : SYMainBasicViewController
/**
 *  搜索按钮点击
 */
-(void)searchClick;

/**
 *  用户按钮点击
 */
-(void)userClick;
@end
