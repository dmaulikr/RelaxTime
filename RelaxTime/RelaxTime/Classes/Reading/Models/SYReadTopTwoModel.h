//
//  SYReadTopTwoModel.h
//  RelaxTime
//
//  Created by imac on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYReadTopTwoModel : NSObject<YYModel>

//作者
@property(nonatomic,copy) NSString* author;
//介绍
@property(nonatomic,copy) NSString* introduction;
//id
@property(nonatomic,copy) NSString* item_id;
//题目
@property(nonatomic,copy) NSString* title;
//类型
@property(nonatomic,copy) NSString* type;


@end
