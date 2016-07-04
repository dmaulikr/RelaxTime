//
//  SYMusicModel.m
//  RelaxTime
//
//  Created by imac on 16/7/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMusicModel.h"

@implementation SYMusicModel

+(NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"story_author":[SYMusicStoryAuthor class], @"author" :[SYMusicAuthor class]};
}


@end


@implementation SYMusicAuthor



@end

@implementation SYMusicStoryAuthor



@end