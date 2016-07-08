//
//  SYCustomActivity.h
//  RelaxTime
//
//  Created by imac on 16/7/8.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYCustomActivity : UIActivity



@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *shareContentArray;

-(instancetype)initWithImage:(UIImage *)shareImage
                       atURL:(NSString *)URL
                     atTitle:(NSString *)title
         atShareContentArray:(NSArray *)shareContentArray;






@end
