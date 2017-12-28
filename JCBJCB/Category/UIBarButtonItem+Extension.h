//
//  UIBarButtonItem+Extension.h
//  LoveGoodFood
//
//  Created by Sorgle on 16/1/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/** 返回带图片的 UIBarButtonItem */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

/** 返回字体的 UIBarButtonItem */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor titleFond:(UIFont *)titleFond;

@end
