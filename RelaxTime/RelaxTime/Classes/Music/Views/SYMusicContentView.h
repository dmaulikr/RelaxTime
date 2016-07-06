//
//  SYMusicContentView.h
//  RelaxTime
//
//  Created by imac on 16/7/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SYMusicContentView;

/// 刷新界面的协议
@protocol SYMusicContentViewDelegate <NSObject>

/**
 *  内容发生改变
 *
 *  @param contentView contentView
 */
-(void)contentViewHasBeenChanged:(SYMusicContentView *)contentView;
/**
 *  播放按钮被点击
 *
 *  @param button 播放按钮
 */
-(void)playButtonClick:(UIButton *)button;

-(void)changeBunttonClick:(UIButton *)button;

@end


@class SYMusicModel;
@interface SYMusicContentView : UIView

@property(nonatomic ,strong) SYMusicModel * model;
/**
 *  播放按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property(nonatomic ,weak) id<SYMusicContentViewDelegate> delegate;

@end
