//
//  SYHomeBeforeSingleController.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYHomeModel;

@interface SYHomeBeforeSingleController : UIViewController
/**
 *  隐藏喜欢按钮
 */
@property(nonatomic ,assign) BOOL hiddenLikeButton;

@property(nonatomic ,strong) SYHomeModel * model;

@end
