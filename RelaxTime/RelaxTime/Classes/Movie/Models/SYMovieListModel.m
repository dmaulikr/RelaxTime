//
//  SYMovieListModel.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieListModel.h"


@implementation SYMovieListModel

+ (NSDictionary *) modelCustomPropertyMapper {
    
    return @{@"movieId":@"id"};
}

- (NSString *)scoretime {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 评分日期
    NSDate *createDate = [fmt dateFromString:_scoretime];
    
    if ([createDate isAfterSomeDays]){
        return @"即将上映";
    }
    return @"显示分数";
}


@end
