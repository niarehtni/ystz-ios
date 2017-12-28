//
//  JCBModel.m
//  yueshangdai
//
//  Created by 黄浚 on 2017/9/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBModel.h"

@implementation JCBModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if (value) {
        [super setValue:value forKey:key];
    }else{
        SGDebugLog(@"key:%@的值为空",key);
    }
}
@end
