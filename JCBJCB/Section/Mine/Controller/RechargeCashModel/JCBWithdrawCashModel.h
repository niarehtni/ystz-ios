//
//  JCBWithdrawCashModel.h
//  JCBJCB
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBWithdrawCashModel : JCBModel
/** userCashChargeTimes */
@property (nonatomic, copy) NSString *userCashChargeTimes;
/** bankName */
@property (nonatomic, copy) NSString *bankName;
/** realName */
@property (nonatomic, copy) NSString *realName;
/** cashMoney */
@property (nonatomic, copy) NSString *cashMoney;
/** cardNo */
@property (nonatomic, copy) NSString *cardNo;
/** ableMoney */
@property (nonatomic, copy) NSString *ableMoney;
/** feeScale */
@property (nonatomic, copy) NSString *feeScale;
/** feeFixed */
@property (nonatomic, copy) NSString *feeFixed;
/** branch */
@property (nonatomic, copy) NSString *branch;
/** cashFeeMoney */
@property (nonatomic, copy) NSString *cashFeeMoney;
/** rmg */
@property (nonatomic, copy) NSString *rmg;
/** cashChargeTimes */
@property (nonatomic, copy) NSString *cashChargeTimes;
/** bankId */
@property (nonatomic, copy) NSString *bankId;
/** rcd */
@property (nonatomic, copy) NSString *rcd;


@end
