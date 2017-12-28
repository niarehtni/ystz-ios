//
//  JCBProjectDescriptionModel.h
//  JCBJCB
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBProjectDescriptionModel : JCBModel
// orderNum
@property (nonatomic, assign) NSString *orderNum;
// capital
@property (nonatomic, assign) CGFloat capital;
// account
@property (nonatomic, assign) CGFloat account;
// repaymentDateInt
@property (nonatomic, assign) NSString *repaymentDateInt;
// interest
@property (nonatomic, assign) CGFloat interest;

@end
