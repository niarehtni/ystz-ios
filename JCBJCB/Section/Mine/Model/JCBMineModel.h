//
//  JCBMineModel.h
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBMineModel : JCBModel
/** realName */
@property (nonatomic, copy) NSString *realName;
/** username */
@property (nonatomic, copy) NSString *username;
/** totalIncome */
@property (nonatomic, assign) CGFloat totalIncome;
/** tenderMoney (投资记录) */
@property (nonatomic, assign) CGFloat tenderMoney;
/** repaymentMoney（回款纪录）*/
@property (nonatomic, assign) CGFloat repaymentMoney;



/** tenderTime */
@property (nonatomic, copy) NSString *tenderTime;
/** investorCollectionCapital */
@property (nonatomic, copy) NSString *investorCollectionCapital;
/** litpic */
@property (nonatomic, copy) NSString *litpic;
/** ableMoney */
@property (nonatomic, copy) NSString *ableMoney;

/** autoTenderStatus */
@property (nonatomic, copy) NSString *autoTenderStatus;
/** total */
@property (nonatomic, copy) NSString *total;
/** gesture */
@property (nonatomic, copy) NSString *gesture;
/** repaymentTime */
@property (nonatomic, copy) NSString *repaymentTime;

/** awardMoney */
@property (nonatomic, copy) NSString *awardMoney;
/** realStatus */
@property (nonatomic, copy) NSString *realStatus;
/** investorCollectionInterest */
@property (nonatomic, copy) NSString *investorCollectionInterest;
/** rcd */
@property (nonatomic, copy) NSString *rcd;
/** rmg */
@property (nonatomic, copy) NSString *rmg;



- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)JCBMineWithDictionary:(NSDictionary *)dict;

@end
