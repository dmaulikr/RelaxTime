//
//  SYSearchControllerViewController.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/5.
//  Copyright © 2016年 abc. All rights reserved.
///Users/IOS1602/Desktop/WorkSpaceRelaxTime/RelaxTime/RelaxTime/Classes/Home/Controllers/SYSearchControllerViewController.m

#import "SYMainBasicViewController.h"

typedef NS_ENUM(NSInteger, searchType) {
     homeVC = 0,
     readVC,
};

@interface SYSearchControllerViewController : SYMainBasicViewController

@property(nonatomic ,assign) searchType type;

@end
