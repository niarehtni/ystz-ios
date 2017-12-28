//
//  SGHelperTool.m
//  JCBJCB
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGHelperTool.h"

@implementation SGHelperTool
/**
 *  根据文字内容计算控件尺寸
 *
 *  @param text     需要计算控件尺寸的文字
 *  @param font     文字的字体
 *  @param maxSize  文字的最大尺寸
 */
+ (CGSize)SG_sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  判断手机号码格式是否正确
 *
 *  @param phoneNumber    手机号码
 */
+ (BOOL)SG_isPhoneNumber:(NSString *)phoneNumber {
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNumber.length != 11) {
        return NO;
    } else {
        /** 移动号段正则表达式 */
        NSString *CM_NUM = @"^((13[4-9])|(14[1,3,7-9])|(15[0-2,4,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /** 联通号段正则表达式 */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[1,6])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
        /** 电信号段正则表达式 */
        NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNumber];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNumber];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNumber];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        } else {
            return NO;
        }
    }
}







@end


