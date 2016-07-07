//
//  SYMovieContentView.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/7.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYMovieContentViewDelegate <NSObject>

-(void)SYMovieContentViewPlayButtonClick;

@end


@class SYMovieDetailModel;
@class SYMovieStoryModel;

@interface SYMovieContentView : UIView


@property(nonatomic ,weak) id<SYMovieContentViewDelegate>  delegate;
/**
 *赋值电影信息数据
 */
-(void)showMessageWithDetaiModel:(SYMovieDetailModel *) detaiModel;

/**
 *  赋值电影故事数据
 */
-(void)showMessageWithStoryModel:(SYMovieStoryModel *)storyModel ;
@end
