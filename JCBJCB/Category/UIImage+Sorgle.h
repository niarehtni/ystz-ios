//
//  UIImage+Sorgle.h
//  LoginRigister
//
//  Created by Sorgle on 16/5/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Sorgle)
/** 等比例缩放 size缩放后的大小*/
- (UIImage *)scaleToSize:(CGSize)size;

/** 返回一张自由拉伸的图片 */
+ (UIImage *)resizableImageWithName:(NSString *)name;

/** 保持原图像不被渲染 */
+ (UIImage *)originalImageWithNamed:(NSString *)imageName;

@end
