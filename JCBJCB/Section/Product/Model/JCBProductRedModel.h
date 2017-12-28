//
//  JCBProductRedModel.h
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBProductRedModel : JCBModel
/** sourceUserId */
@property (nonatomic, copy) NSString *sourceUserId;
/** isPc */
@property (nonatomic, copy) NSString *isPc;
/** modifyDate */
@property (nonatomic, copy) NSString *modifyDate;
/** status */
@property (nonatomic, copy) NSString *status;
/** hbNo */
@property (nonatomic, copy) NSString *hbNo;
/** money */
@property (nonatomic, copy) NSString *money;
/** source */
@property (nonatomic, copy) NSString *source;
/** sourceBorrowId */
@property (nonatomic, copy) NSString *sourceBorrowId;
/** isApp */
@property (nonatomic, copy) NSString *isApp;
/** isHfive */
@property (nonatomic, copy) NSString *isHfive;
/** limitStart */
@property (nonatomic, copy) NSString *limitStart;
/** endTime */
@property (nonatomic, copy) NSString *endTime;
/** name */
@property (nonatomic, copy) NSString *name;
/** usedBorrowId */
@property (nonatomic, copy) NSString *usedBorrowId;
/** overDays */
@property (nonatomic, copy) NSString *overDays;
/** id */
@property (nonatomic, copy) NSString *ID;
/** investFullMomey */
@property (nonatomic, copy) NSString *investFullMomey;
/** usedMoney */
@property (nonatomic, copy) NSString *usedMoney;
/** limitEnd */
@property (nonatomic, copy) NSString *limitEnd;
/** isLooked */
@property (nonatomic, copy) NSString *isLooked;
/** on */
@property (nonatomic, copy) NSString *on;
/** createDate */
@property (nonatomic, copy) NSString *createDate;
/** startTime */
@property (nonatomic, copy) NSString *startTime;
/** sourceString */
@property (nonatomic, copy) NSString *sourceString;
/** expDate */
@property (nonatomic, copy) NSString *expDate;
/** userId */
@property (nonatomic, copy) NSString *userId;


@property (nonatomic,  assign) BOOL isSelected;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)JCBProductRedModelWithDictionary:(NSDictionary *)dict;

@end

