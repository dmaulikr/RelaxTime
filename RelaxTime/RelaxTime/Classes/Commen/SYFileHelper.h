//
//  SYFileHelper.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/9.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFileHelper : NSObject

//获取大小
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath;

//删除文件夹
+(BOOL)clearAtPath:(NSString *)filePath;
@end
