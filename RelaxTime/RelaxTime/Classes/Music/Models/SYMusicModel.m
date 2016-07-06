//
//  SYMusicModel.m
//  RelaxTime
//
//  Created by imac on 16/7/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMusicModel.h"


#define HeightNormal WIDTH + 100 + 60 + 20
@implementation SYMusicModel

+(NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"story_author":[SYMusicStoryAuthor class], @"author" :[SYMusicAuthor class]};
}
//去掉<br>
-(NSString *)story{
    _story = [_story stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    return _story;
}

-(CGFloat)lyrHeight{
    //100为中间view高度
    //width为图片高度
    //60 为textView距中间view的距离
    return HeightNormal + [self calculateWithString:self.lyric];
}

-(CGFloat)musicStroyTextHeight{
  
    return HeightNormal + [self calculateWithString:self.story];
}

-(CGFloat)infoHeigt{
   
    return HeightNormal + [self calculateWithString:self.info];
}

-(CGFloat)calculateWithString:(NSString *)str{
    
   CGRect rect  =  [str boundingRectWithSize:CGSizeMake(WIDTH - 20, MAXFLOAT) options:1 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height;
}
@end


@implementation SYMusicAuthor



@end

@implementation SYMusicStoryAuthor



@end