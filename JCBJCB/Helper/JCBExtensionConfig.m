//
//  JCBExtensionConfig.m
//  JCBJCB
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBExtensionConfig.h"

@implementation JCBExtensionConfig

+ (void)load {
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}

@end
