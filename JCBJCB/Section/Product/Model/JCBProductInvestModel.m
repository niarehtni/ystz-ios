//
//  JCBProductInvestModel.m
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductInvestModel.h"

@implementation JCBProductInvestModel

// 自定义初始化方法 ---- 将字典对象封装成Model类的对象.
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.ID = [dict objectForKey:@"id"];
    }
    return self;
}
+ (instancetype)JCBProductInvestWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
