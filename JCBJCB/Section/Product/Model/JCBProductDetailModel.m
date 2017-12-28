//
//  JCBProductDetailModel.m
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailModel.h"

@implementation JCBProductDetailModel

// 自定义初始化方法 ---- 将字典对象封装成Model类的对象.
- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
