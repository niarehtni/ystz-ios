//
//  JCBFourCellModel.h
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBFourCellModel : JCBModel

/** id */
@property(nonatomic, copy) NSString *ID;

/** name */
@property(nonatomic, copy) NSString *name;

/** baseApr */
@property (nonatomic, assign) CGFloat baseApr;

/** awardApr */
@property (nonatomic, assign) CGFloat awardApr;

/** timeLimit */
@property (nonatomic, assign) NSInteger timeLimit;

/** account */
@property (nonatomic, assign) NSInteger account;

/** balance */
@property (nonatomic, assign) NSInteger balance;

// 进度条
@property (nonatomic, assign) CGFloat schedule;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
