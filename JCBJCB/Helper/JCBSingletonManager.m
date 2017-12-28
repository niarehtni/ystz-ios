//
//  JCBSingletonManager.m
//  JCBJCB
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBSingletonManager.h"

@implementation JCBSingletonManager

+ (instancetype)sharedSingletonManager {
    static JCBSingletonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JCBSingletonManager alloc] init];
    });
    return manager;
}


@end

