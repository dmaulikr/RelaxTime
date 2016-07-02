//
//  SYReadQuesModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYReadQuesModel : NSObject

//答案内容
@property(nonatomic ,copy) NSString * answer_content;
//答案题目
@property(nonatomic ,copy) NSString * answer_title;
//问题id
@property(nonatomic ,copy) NSString * question_id;
//问题时间
@property(nonatomic ,copy) NSString * question_makettime;
//问题标题
@property(nonatomic ,copy) NSString * question_title;

@end
