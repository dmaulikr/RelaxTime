//
//  SYReadContentView.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYReadContentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property(nonatomic ,strong) id  model;

@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@end
