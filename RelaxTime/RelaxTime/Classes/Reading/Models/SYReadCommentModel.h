//
//  SYReadCommentModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYReadCommentUser;

@interface SYReadCommentModel : NSObject<YYModel>

//评论数量
//@property(nonatomic ,assign) NSInteger count;

@property(nonatomic ,copy) NSString * _id;
//内容
@property(nonatomic ,copy) NSString * content;
//发布时间
@property(nonatomic ,copy) NSString * input_date;

//点赞数
@property(nonatomic ,copy) NSString * praisenum;

//用户
@property(nonatomic ,strong) SYReadCommentUser * user;
@end


@interface SYReadCommentUser : NSObject
//id
@property(nonatomic ,copy) NSString * user_id;
//名字
@property(nonatomic ,copy) NSString * user_name;
//头像
@property(nonatomic ,copy) NSString * web_url;



@end