//
//  NSString+SGExtension.m
//  NSString+SGExtension
//
//  Created by Sorgle on 15/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//
//  Base64编码本质上是一种将二进制数据转成文本数据的方案。对于非二进制数据，是先将其转换成二进制形式，然后每连续6比特（2的6次方=64）计算其十进制值，根据该值在上面的索引表中找到对应的字符，最终得到一个文本字符串

#import "NSString+SGExtension.h"

@implementation NSString (SGExtension)

- (BOOL)match:(NSString *)pattern {
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

- (BOOL)SG_isPhoneNumber{
    // 1.全部是数字
    // 2.11位
    // 3.以13\15\18\17开头
    return [self match:@"^1[3578]\\d{9}$"];
    // JavaScript的正则表达式:\^1[3578]\\d{9}$\

}


/** 正则表达式判断输入身份证号码是否正确 */
- (BOOL)SG_isIdentityCard {
    return [self match:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}


- (NSString *)SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:(NSString *)urlString {
    NSString *user_accessToken;
    
//    NSURL *url = [NSURL URLWithString:urlString];
//    if (url.query) {
//        
//    }
//    [urlString containsString:@"?"]
    // 在urlStr这个字符串中搜索\n，判断有没有
    if ([urlString rangeOfString:@"?"].location != NSNotFound) {
        
        user_accessToken = [NSString stringWithFormat:@"%@&token=%@", urlString, [[NSUserDefaults standardUserDefaults] objectForKey:userAccessToken]];
        
    } else {
        user_accessToken = [NSString stringWithFormat:@"%@?token=%@", urlString, [[NSUserDefaults standardUserDefaults] objectForKey:userAccessToken]];
    }
    
     return [user_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/* 时间格式的转换 */
- (NSString *)SG_transformationTimeFormatWithTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000];
    NSString *ok_time = [formatter stringFromDate:date];
    return ok_time;
}
/* 时间格式的转换(yyyy-MM-dd) */
- (NSString *)SG_transformationTimeFormatWithYMDTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000];
    NSString *ok_time = [formatter stringFromDate:date];
    return ok_time;
}

/* 拼接字符串 */
- (NSString *)SG_addString:(NSString *)string {
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Replace particular characters in my string with new character
- (NSString *)SG_replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar {
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

- (NSString *)SG_replaceCharcterInRange:(NSRange)rang withCharcter:(NSString *)newerChar {
    return [self stringByReplacingCharactersInRange:rang withString:newerChar];
}

/** 转换为Base64编码 */
- (NSString *)SG_Base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
/** 将Base64编码还原 */
- (NSString *)SG_Base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


@end



