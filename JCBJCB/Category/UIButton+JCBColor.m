//
//  UIButton+JCBColor.m
//  yueshangdai
//
//  Created by 黄浚 on 2017/10/8.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "UIButton+JCBColor.h"

@implementation UIButton (JCBColor)
- (void)setBackgroundImageWithColor:(UIColor *)color forState:(UIControlState)state{
    UIImage *img = [self imageForColor:color];
    [self setBackgroundImage:img forState:state];
}

- (UIImage *)imageForColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), YES, [UIScreen mainScreen].scale);
    [color setFill];
    UIBezierPath *b = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, 1)];
    [b fill];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}
@end
