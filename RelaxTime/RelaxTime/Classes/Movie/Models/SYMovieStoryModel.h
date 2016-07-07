//
//  SYMovieStoryModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class storyUser;
@interface SYMovieStoryModel : NSObject <YYModel>


@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *movie_id;

@property (nonatomic, assign) NSInteger praisenum;

@property (nonatomic, copy) NSString *story_type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *input_date;

@property (nonatomic, strong) storyUser *user;


/**
 *  音乐故事的高度
 */
@property(nonatomic ,assign) CGFloat storyHeight;

@end


@interface storyUser : NSObject

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *web_url;
@end
