//
//  SYReadSeriesModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  阅读界面连载模型
 */

@class SYReadSeriousAuthor;
@interface SYReadSeriesModel : NSObject<YYModel>



//作者信息
@property(nonatomic , strong) SYReadSeriousAuthor * author;

//引导词
@property(nonatomic ,copy) NSString * excerpt;

//有无音频
@property(nonatomic ,copy) NSString * has_audio;

//时间
@property(nonatomic ,copy) NSString * maketime;

//标题
@property(nonatomic ,copy) NSString * title;

//阅读数量
@property(nonatomic ,copy) NSString * read_num;

//系列id
@property(nonatomic ,copy) NSString *item_id;

//文章内容
@property(nonatomic ,copy) NSString *content;

//喜欢数
@property(nonatomic ,copy) NSString *praisenum;
//分享数
@property(nonatomic ,copy) NSString *sharenum;
//评论数
@property(nonatomic ,copy) NSString *commentnum;

/**
 *  通过计算得出显示的内容高度
 */

@property(nonatomic ,assign) CGFloat contentViewHeight;




@end

/**
 *  作者信息
 */
@interface SYReadSeriousAuthor: NSObject<YYModel>

//id
@property(nonatomic ,copy) NSString * user_id;

//描述
@property(nonatomic ,copy) NSString * desc;

//名字
@property(nonatomic ,copy) NSString * user_name;

//微博头像

@property(nonatomic ,copy) NSString * web_url;

@end
