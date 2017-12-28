//
//  JCBProductRedModel.m
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductRedModel.h"

@implementation JCBProductRedModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.ID = [dict objectForKey:@"id"];
    }
    return self;
}
+ (instancetype)JCBProductRedModelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
