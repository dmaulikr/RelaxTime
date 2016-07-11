//
//  BasicDataManager.m
//  SYFreeLimit
//
//  Created by 千锋 on 16/6/16.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "BasicDataManager.h"
#import <FMDB.h>

@interface BasicDataManager()

@property(nonatomic, strong) FMDatabase * db;

@end

@implementation BasicDataManager

//单例
+ (instancetype)manager {
    
    static BasicDataManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}



#pragma mark - 懒加载
-(FMDatabase *)db{
    if (!_db) {
        NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/HpLike.db"];
        
        //创建数据库
        _db = [[FMDatabase alloc]initWithPath:path];
        
        //打开数据库
        BOOL ret = [_db open];
        
        if (ret) {
            SYLog(@"数据库打开成功");
        }else{
            SYLog(@"数据库打开失败");
        }
        
        [self creatTable];
        
    }
    
    return _db;
}

#pragma mark - 创建表

-(void)creatTable{
 
    //创建sql语句
    NSString *sql = @"CREATE TABLE IF NOT EXISTS  t_hpLikeTable (id integer PRIMARY KEY AUTOINCREMENT, hpcontent_id text UNIQUE, hp_img_original_url text,last_update_date text, hp_content text,hp_author text);";
    
    BOOL ret = [_db executeUpdate:sql];
    
    if (ret) {
        SYLog(@"表打开成功");
    }else{
        SYLog(@"表打开失败");
    }
}

-(void)insertDataWithModel:(SYHomeModel *)model{
    
 
    
    NSString *sql = @"INSERT INTO t_hpLikeTable(hpcontent_id, hp_img_original_url,last_update_date, hp_content ,hp_author ) VALUES(?,?,?,?,?);";
    
    //执行sql语句
    BOOL ret = [ self.db executeUpdate:sql,model.hpcontent_id,model.hp_img_original_url,model.last_update_date,model.hp_content,model.hp_author];
    if (ret) {
        SYLog(@"插入成功");
    }else{
        SYLog(@"插入失败");
    }
}

#pragma mark - 检查指定的数据是否已经收藏
-(BOOL)checkIsInDBWithhpContentId:(NSString *)ContentId{

    NSString *sql = @"SELECT count(*) FROM t_hpLikeTable WHERE hpcontent_id = ?;";
    
    //查询
    FMResultSet *set = [self.db executeQuery:sql,ContentId];
    
    while ([set next]) {
        
       int count = [set intForColumnIndex:0];
        
        
        if (count > 0) {
            return YES;
        }
        return NO;
        
    }
    
    return NO;

}


-(NSArray *)getAllModel{
    NSString *sql = @"SELECT * FROM t_hpLikeTable;";
    
    FMResultSet *set = [self.db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
        
        //创建模型来放数据
        SYHomeModel *model = [SYHomeModel new];
        
        model.hpcontent_id = [set stringForColumn:@"hpcontent_id"];
        
        model.hp_author = [set stringForColumn:@"hp_author"];
        
        model.hp_content = [set stringForColumn:@"hp_content"];
        
        model.hp_img_original_url = [set stringForColumn:@"hp_img_original_url"];
        model.last_update_date = [set stringForColumn:@"last_update_date"];
        //保存模型
        
        [array addObject:model];
    }
    
    return [array copy];
}


-(void)deleteDataWithContentId:(NSString *)ContentId{

    NSString *sql = @"DELETE FROM t_hpLikeTable WHERE hpcontent_id = ?;";
    BOOL ret = [self.db executeUpdate:sql, ContentId];
    if (ret) {
        SYLog(@"删除成功");
    }else{
        SYLog(@"删除失败");
    }
    
}

-(void)deleteDataWithIds:(NSArray *)idArray{
    
    for (NSString * ID in idArray) {
        [self deleteDataWithContentId:ID];
    }
    
}

@end
