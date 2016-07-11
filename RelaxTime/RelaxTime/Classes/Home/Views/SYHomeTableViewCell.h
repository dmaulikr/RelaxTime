//
//  SYHomeTableViewCell.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYHomeModel;

@interface SYHomeTableViewCell : UITableViewCell

//喜欢按钮
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property(nonatomic, strong) SYHomeModel *model;
@end
