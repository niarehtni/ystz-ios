//
//  JCBUserCenterModel.h
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBUserCenterModel : JCBModel
/** rmg */
@property (nonatomic, copy) NSString *rmg;
/** rcd */
@property (nonatomic, copy) NSString *rcd;
/** realStatus */
@property (nonatomic, copy) NSString *realStatus;
/** realName */
@property (nonatomic, copy) NSString *realName;
/** username */
@property (nonatomic, copy) NSString *username;
/** ableMoney 可用金额*/
@property (nonatomic, copy) NSString *ableMoney;
/** total */
@property (nonatomic, copy) NSString *total;
/** repaymentMoney */
@property (nonatomic, copy) NSString *repaymentMoney;
/** userId */
@property (nonatomic, copy) NSString *userId;
/** repaymentTime */
@property (nonatomic, copy) NSString *repaymentTime;
/** awardMoney */
@property (nonatomic, copy) NSString *awardMoney;
/** gesture */
@property (nonatomic, copy) NSString *gesture;
/** investorCollectionInterest */
@property (nonatomic, copy) NSString *investorCollectionInterest;
/** autoTenderStatus */
@property (nonatomic, copy) NSString *autoTenderStatus;
/** tenderMoney */
@property (nonatomic, copy) NSString *tenderMoney;
/** tenderTime */
@property (nonatomic, copy) NSString *tenderTime;
/** investorCollectionCapital */
@property (nonatomic, copy) NSString *investorCollectionCapital;
/** litpic */
@property (nonatomic, copy) NSString *litpic;
/** totalIncome */
@property (nonatomic, copy) NSString *totalIncome;

@end
