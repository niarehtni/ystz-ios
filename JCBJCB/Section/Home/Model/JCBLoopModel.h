//
//  JCBLoopModel.h
//  JCBJCB
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBLoopModel : JCBModel
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *typeTarget;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
