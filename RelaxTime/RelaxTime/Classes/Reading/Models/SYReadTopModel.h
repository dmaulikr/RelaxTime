//
//  SYReadTopModel.h
//  RelaxTime
//
//  Created by imac on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYReadTopModel : NSObject<YYModel>

//背景颜色
@property(nonatomic,copy) NSString* bgcolor;
//底部文字
@property(nonatomic,copy) NSString* bottom_text;
//封面
@property(nonatomic,copy) NSString* cover;
//id
@property(nonatomic,copy) NSString* _id;
//题目
@property(nonatomic,copy) NSString* title;
@end

