//
//  SYHomeModel.h
//  RelaxTime
//
//  Created by imac on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHomeModel : NSObject<YYModel>

//图片
@property (nonatomic, copy) NSString *hp_img_original_url;
//vol.xxxx
@property (nonatomic, copy) NSString *hp_title;
//喜欢数量
@property (nonatomic, copy) NSString * praisenum;

//发表时间

@property (nonatomic, copy) NSString *last_update_date;
//内容
@property (nonatomic, copy) NSString *hp_content;
//评论数量
@property (nonatomic, copy) NSString * commentnum;

//作者名字
@property (nonatomic, copy) NSString *hp_author;

//分享数
@property (nonatomic, copy) NSString * sharenum;

//文章Id

@property (nonatomic, copy) NSString *hpcontent_id;

@end
