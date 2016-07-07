//
//  SYMovieListModel.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMovieListModel : NSObject<YYModel>

/**图片url*/
@property (nonatomic, copy) NSString *cover;
/**电影id*/
@property (nonatomic, copy) NSString *movieId;
/** 分数 */
@property (nonatomic, assign) NSInteger score;
/**分数事件*/
@property (nonatomic, copy) NSString *scoretime;
/**标题*/
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *releasetime;

@property (nonatomic, assign) NSInteger revisedscore;

@property (nonatomic, copy) NSString *servertime;


@end
