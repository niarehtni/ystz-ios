//
//  JCBPayBackModel.h
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBPayBackModel : JCBModel

/** waitInterest */
@property (nonatomic, copy) NSString *waitInterest;
/** serviceCharge */
@property (nonatomic, copy) NSString *serviceCharge;
/** waitAccount */
@property (nonatomic, copy) NSString *waitAccount;
/** periods */
@property (nonatomic, copy) NSString *periods;
/** repaymentPeriods */
@property (nonatomic, copy) NSString *repaymentPeriods;
/** borrowName */
@property (nonatomic, copy) NSString *borrowName;
/** waitTotal */
@property (nonatomic, copy) NSString *waitTotal;
/** repaymentStatus */
@property (nonatomic, copy) NSString *repaymentStatus;
/** repaymentStatusShow */
@property (nonatomic, copy) NSString *repaymentStatusShow;
/** repaymentDate */
@property (nonatomic, copy) NSString *repaymentDate;

@end
