//
//  BasicDataManager.h
//  SYFreeLimit
//
//  Created by 千锋 on 16/6/16.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYHomeModel.h"


@interface BasicDataManager : NSObject

/**
 *  单例
 *
 *  @return 数据库管理类单例对象
 */
+ (instancetype)manager;

//将模型出入到数据库中

-(void)insertDataWithModel:(SYHomeModel *)model;

//判断指定的模型在数据库中是否存在

-(BOOL)checkIsInDBWithhpContentId:(NSString *)ContentId;

//获取数据库中所有的数据

-(NSArray *)getAllModel;

//删除指定的数据

-(void)deleteDataWithContentId:(NSString *)ContentId;

@end
