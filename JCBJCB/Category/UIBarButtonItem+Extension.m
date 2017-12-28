//
//  UIBarButtonItem+Extension.m
//  LoveGoodFood
//
//  Created by Sorgle on 16/1/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    // 设置图片
    [button setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:(UIControlStateHighlighted)];
    // Button点击事件
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    // 设置尺寸
    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

// 设置UIBarButtonItem的字体
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor titleFond:(UIFont *)titleFond {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:titleColor forState:(UIControlStateNormal)];
    button.titleLabel.font = titleFond;
    // Button点击事件
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    // 设置尺寸
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
