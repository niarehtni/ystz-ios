//
//  SGSmallTool.m
//  SGSmallTool
//
//  Created by Sorgle on 12/12/15.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import "SGSmallTool.h"

@implementation SGSmallTool

/**
 *  给控件设置圆角
 *
 *  @param view     需要设置圆角的视图
 *  @param cornerRadius     圆角的大小
 */
+ (void)SG_smallWithThisView:(UIView *)view cornerRadius:(CGFloat)cornerRadius {
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
}
/**
 *  给控件设置边框及颜色
 *
 *  @param view     需要设置边框及颜色的视图
 *  @param borderWidth     边框宽度
 *  @param borderColor     边框颜色
 */
+ (void)SG_smallWithThisView:(UIView *)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = [borderColor CGColor];
}
/**
 *  给控件添加轻拍（单击）手势
 *
 *  @param view     需要添加手势的视图
 *  @param target     执行者
 *  @param action     手势事件
 */
+ (void)SG_smallWithTapGestureRecognizerToThisView:(UIView *)view target:(id)target action:(SEL)action {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:gesture];
}
/**
 *  设置UILabel文字的不同颜色与大小
 *
 *  @param label     需要设置的Label
 *  @param frontText     前面文字
 *  @param behindText     后面文字
 *  @param behindTextColor     后面文字的字体颜色
 *  @param behindTextFont     后面文字的字体大小
 *  @param centerLineBool     是否添加中间横线
 */
+ (void)SG_smallWithThisLabel:(UILabel *)label frontText:(NSString *)frontText behindText:(NSString *)behindText behindTextColor:(UIColor *)behindTextColor behindTextFont:(CGFloat)behindTextFont centerLineBool:(BOOL)centerLineBool {
    // rangeOfString 如果想知道字符串内的某处是否包含其他的字符串
    // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
    NSRange rangeStr = [label.text rangeOfString:behindText];
    if (rangeStr.location != NSNotFound) { // 包含
        // 设置格式 (带属性的字符串)在iOS开发中，常常会有一段文字显示不同的颜色和字体，或者给某几个文字加删除线或下划线的需求
        NSMutableAttributedString *strText = [[NSMutableAttributedString alloc] initWithString:label.text];
        // 为某一范围内文字添加某个属性
        [strText addAttribute:NSForegroundColorAttributeName value:behindTextColor range:NSMakeRange(frontText.length, behindText.length)];
        // 设置字体大小
        [strText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:behindTextFont] range:NSMakeRange(frontText.length, behindText.length)];
        if (centerLineBool) {
            [strText addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(frontText.length, behindText.length)];
        }
        label.attributedText = strText;
    }
}

@end

/*
 使用方法：
     为某一范围内文字设置多个属性
     - (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
     为某一范围内文字添加某个属性
     - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
     为某一范围内文字添加多个属性
     - (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
     移除某范围内的某个属性
     - (void)removeAttribute:(NSString *)name range:(NSRange)range;
 */
