//
//  SYSecret.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SYSecretController : UIViewController

@property(nonatomic ,copy) NSString * phoneNumber;
@property(nonatomic ,copy) void(^block)() ;

@end
