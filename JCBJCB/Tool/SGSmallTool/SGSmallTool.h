//
//  SGSmallTool.h
//  SGSmallTool
//
//  Created by Sorgle on 12/12/15.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGSmallTool : NSObject

/** 给控件设置圆角 */
+ (void)SG_smallWithThisView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

/** 给控件设置边框及颜色 */
+ (void)SG_smallWithThisView:(UIView *)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 给控件添加轻拍（单击）手势 */
+ (void)SG_smallWithTapGestureRecognizerToThisView:(UIView *)view target:(id)target action:(SEL)action;

/** 设置UILabel文字的不同颜色与大小 */
+ (void)SG_smallWithThisLabel:(UILabel *)label frontText:(NSString *)frontText behindText:(NSString *)behindText behindTextColor:(UIColor *)behindTextColor behindTextFont:(CGFloat)behindTextFont centerLineBool:(BOOL)centerLineBool;


@end
