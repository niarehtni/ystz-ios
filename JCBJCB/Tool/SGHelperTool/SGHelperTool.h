//
//  SGHelperTool.h
//  JCBJCB
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGHelperTool : NSObject
/** 根据文字内容计算控件的尺寸 */
+ (CGSize)SG_sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/** 判断手机号码格式是否正确 */
+ (BOOL)SG_isPhoneNumber:(NSString *)phoneNumber;

@end
