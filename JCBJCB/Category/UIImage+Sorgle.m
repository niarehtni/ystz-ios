//
//  UIImage+Sorgle.m
//  LoginRigister
//
//  Created by Sorgle on 16/5/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "UIImage+Sorgle.h"

@implementation UIImage (Sorgle)

/** 等比例缩放 */
- (UIImage *)scaleToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/** 返回一张自由拉伸的图片 */
+ (UIImage *)resizableImageWithName:(NSString *)name{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

/** 保持原图像不被渲染 */
+ (UIImage *)originalImageWithNamed:(NSString *)imageName{
    UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
@end


