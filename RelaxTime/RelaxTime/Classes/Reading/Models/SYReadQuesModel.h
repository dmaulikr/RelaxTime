//
//  SYReadQuesModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYReadQuesModel : NSObject<YYModel>

//答案内容
@property(nonatomic ,copy) NSString * answer_content;
//答案题目
@property(nonatomic ,copy) NSString * answer_title;
//问题id
@property(nonatomic ,copy) NSString * item_id;
//问题时间
@property(nonatomic ,copy) NSString * question_makettime;
//问题标题
@property(nonatomic ,copy) NSString * question_title;

//问题内容
@property(nonatomic ,copy) NSString * question_content;
//评论数
@property(nonatomic ,copy) NSString * commentnum;
//点赞数
@property(nonatomic ,copy) NSString * praisenum;
//阅读数
@property(nonatomic ,copy) NSString * read_num;
//分享数
@property(nonatomic ,copy) NSString * sharenum;

/**
 *  通过计算得出显示的内容高度
 */

@property(nonatomic ,assign) CGFloat contentViewHeight;

@end
