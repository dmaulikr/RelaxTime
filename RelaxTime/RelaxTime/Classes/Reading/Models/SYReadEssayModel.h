//
//  SYReadEssayModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  阅读界面短文模型
 */
@interface SYReadEssayModel : NSObject<YYModel>

//作者信息
@property(nonatomic ,copy) NSArray * author;

//引导词
@property(nonatomic ,copy) NSString * guide_word;

//有无音频
@property(nonatomic ,copy) NSString * has_audio;

//时间
@property(nonatomic ,copy) NSString * hp_makettime;

//标题
@property(nonatomic ,copy) NSString * hp_title;

//内容id

@property(nonatomic ,copy) NSString * item_id;

//文章内容
@property(nonatomic ,copy) NSString *hp_content;

//评论数
@property(nonatomic ,copy) NSString * commentnum;

//作者
@property(nonatomic ,copy) NSString * hp_author;

//喜欢数
@property(nonatomic ,copy) NSString * praisenum;

//分享数量
@property(nonatomic ,copy) NSString * sharenum;

/**
 *  通过计算得出显示的内容高度
 */

@property(nonatomic ,assign) CGFloat contentViewHeight;

@end

/**
 *  作者信息
 */
@interface SYReadEssayAuthor: NSObject<YYModel>

//id
@property(nonatomic ,copy) NSString * user_id;

//描述
@property(nonatomic ,copy) NSString * desc;

//名字
@property(nonatomic ,copy) NSString * user_name;

//微博名字

@property(nonatomic ,copy) NSString * wb_name;
//微博头像

@property(nonatomic ,copy) NSString * web_url;

@end