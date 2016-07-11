//
//  SYLoginRegisterViewController.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol SYLoginRegisterViewController <NSObject>

-(void)changeUser;

@end

@interface SYLoginRegisterViewController : UIViewController


@property(nonatomic ,weak) id<SYLoginRegisterViewController> delegate;
@end
