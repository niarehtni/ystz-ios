//
//  NSString+SGExtension.h
//  NSString+SGExtension
//
//  Created by Sorgle on 15/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SGExtension)

/** 正则表达式判断输入手机号是否正确 */
- (BOOL)SG_isPhoneNumber;
/** 正则表达式判断输入身份证号码是否正确 */
- (BOOL)SG_isIdentityCard;
/** 正则表达式判断输入银行卡号是否正确 */
//- (BOOL)SG_isBankCardNumber:(NSString *)BKCardNum;

/** 用户登录之后再次请求前拼接Token值 */
- (NSString *)SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:(NSString *)urlString;

/* 时间格式的转换(yyyy-MM-dd HH:mm:ss) */
- (NSString *)SG_transformationTimeFormatWithTime:(NSString *)time;
/* 时间格式的转换(yyyy-MM-dd) */
- (NSString *)SG_transformationTimeFormatWithYMDTime:(NSString *)time;

/* 拼接字符串 */
- (NSString *)SG_addString:(NSString *)string;
/* 用新字符串替换旧的字符串 */
- (NSString *)SG_replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
/* 截取字符串并用新的字符串替换 */
- (NSString *)SG_replaceCharcterInRange:(NSRange)rang withCharcter:(NSString *)newerChar;


/** 转换为Base64编码 */
- (NSString *)SG_Base64EncodedString;
/** 将Base64编码还原 */
- (NSString *)SG_Base64DecodedString;


@end
