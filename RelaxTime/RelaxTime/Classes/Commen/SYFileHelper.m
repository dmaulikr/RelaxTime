//
//  SYFileHelper.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/9.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYFileHelper.h"

@implementation SYFileHelper

// 文件夹大小(字节)
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

//单个文件的大小(字节)
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//删除文件夹和内容
+(BOOL)clearAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:filePath error:nil];
    
    return YES;
    
}
@end
