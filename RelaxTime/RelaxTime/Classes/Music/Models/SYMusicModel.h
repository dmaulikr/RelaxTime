//
//  SYMusicModel.h
//  RelaxTime
//
//  Created by imac on 16/7/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SYMusicStoryAuthor;
@class SYMusicAuthor;
/**
 *  音乐内容模型
 */
@interface SYMusicModel : NSObject<YYModel>

//歌名
@property(nonatomic,copy) NSString* title;
//专辑信息
@property(nonatomic,copy) NSString* info;
//封面
@property(nonatomic,copy) NSString* cover;
//歌词
@property(nonatomic,copy) NSString* lyric;
//音乐id
@property(nonatomic,copy) NSString* music_id;
//点赞数
@property(nonatomic,copy) NSString* praisenum;
//分享数
@property(nonatomic,copy) NSString* sharenum;
/**
 *  音乐故事可能为空
 */
@property(nonatomic,copy) NSString* story;
//故事题目
@property(nonatomic,copy) NSString* story_title;
//故事作者
@property(nonatomic,strong) SYMusicStoryAuthor* story_author;

@property(nonatomic,strong) SYMusicAuthor* author;



/**
 *  音乐故事对应的contentView高度
 */
@property(nonatomic ,assign) CGFloat musicStroyTextHeight;

/**
 *  歌词对应的contentView高度
 */
@property(nonatomic ,assign) CGFloat lyrHeight;

/**
 *  歌曲信息对应的contentView高度
 */
@property(nonatomic ,assign) CGFloat infoHeigt;

@end




/**
 *  音乐故事作者
 */
@interface SYMusicStoryAuthor : NSObject<YYModel>

@property(nonatomic,copy) NSString * user_id;
@property(nonatomic,copy) NSString * user_name;


@end





/**
 *  音乐作者
 */
@interface SYMusicAuthor : NSObject<YYModel>
/**
 *  描述
 */
@property(nonatomic,copy) NSString * desc;

@property(nonatomic,copy) NSString * user_name;

@property(nonatomic,copy) NSString * user_id;
/**
 *  作者头像
 */
@property(nonatomic,copy) NSString * web_url;




@end
