//
//  UITextField+SGExtension.m
//  UITextField+SGExtension
//
//  Created by Sorgle on 15/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import "UITextField+SGExtension.h"

static NSString * const SGPlaceholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (SGExtension)

- (void)setSG_placeholderColor:(UIColor *)SG_placeholderColor {
    // 提前设置占位文字, 目的 : 让它提前创建placeholderLabel
    NSString *oldPlaceholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = oldPlaceholder;
    
    // 恢复到默认的占位文字颜色
    if (SG_placeholderColor == nil) {
        SG_placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    
    // 设置占位文字颜色
    [self setValue:SG_placeholderColor forKeyPath:SGPlaceholderColorKey];
}

- (UIColor *)SG_placeholderColor {
    return [self valueForKeyPath:SGPlaceholderColorKey];
}

@end
