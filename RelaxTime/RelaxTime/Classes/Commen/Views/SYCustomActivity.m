//
//  SYCustomActivity.m
//  RelaxTime
//
//  Created by imac on 16/7/8.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYCustomActivity.h"

@implementation SYCustomActivity
- (instancetype)initWithImage:(UIImage *)shareImage
                        atURL:(NSString *)URL
                      atTitle:(NSString *)title
          atShareContentArray:(NSArray *)shareContentArray {
    if (self = [super init]) {
        _shareImage = shareImage;
        _URL = URL;
        _title = title;
        _shareContentArray = shareContentArray;
    }
    return self;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return _title;
}

- (NSString *)activityTitle {
    return _title;
}

- (UIImage *)activityImage {
    return _shareImage;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (UIViewController *)activityViewController {
    return nil;
}

- (void)performActivity {
    if (nil == _title) {
        return;
    }
    
    SYLog(@"%@", _shareContentArray);
    SYLog(@"%@", _title);
        
        if(nil == _title) {
            
            return;
            
        }
        
        if([_title isEqualToString:@"share Renren"]){
            
            NSLog(@"---^^^  renren");
            
            //调用人人的sdk
            
        }else if([_title isEqualToString:@"share Sina"]){
            
            //调用新浪sdk
            
        }
        
    
    
    

    
    [self activityDidFinish:YES];//默认调用传递NO
}

- (void)activityDidFinish:(BOOL)completed {
    if (completed) {
        SYLogFunc;
    }
}

@end
