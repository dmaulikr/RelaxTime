//
//  SYReadBottomCell.h
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//



#import <UIKit/UIKit.h>


@protocol SYReadCellDelegate<NSObject>

-(void)pushControllerWithType:(ReadType)type andItemsID:(NSString *)itemsID;

@end

@interface SYReadBottomCell : UICollectionViewCell

//数据源
@property(nonatomic ,copy) NSArray * dataArray;
/**
 *  代理
 */
@property(nonatomic ,weak) id<SYReadCellDelegate>  delegate;

@end
