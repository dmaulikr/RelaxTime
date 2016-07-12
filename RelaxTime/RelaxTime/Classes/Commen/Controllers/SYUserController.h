//
//  SYUserController.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYUserController <NSObject>

-(void)changeUser;

@end
@interface SYUserController : UITableViewController

@property(nonatomic ,weak) id<SYUserController> delegate;
@end
