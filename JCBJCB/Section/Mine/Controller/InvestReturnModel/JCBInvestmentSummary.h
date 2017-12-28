//
//  JCBInvestmentSummary.h
//  JCBJCB
//
//  Created by apple on 17/1/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBInvestmentSummary : JCBModel
@property (nonatomic, copy) NSString *repaymentDate;
@property (nonatomic, copy) NSString *waitInterest;
@property (nonatomic, copy) NSString *waitAccount;

@end
