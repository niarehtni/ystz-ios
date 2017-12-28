//
//  JCBInvestmentRecordModel.h
//  JCBJCB
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBInvestmentRecordModel : JCBModel
// id
@property (nonatomic, assign) CGFloat tenderId;
// 用户名
@property (nonatomic, copy) NSString *username;
// 投资时间
@property (nonatomic, assign) CGFloat createDate;
// 投资金额
@property (nonatomic, assign) CGFloat money;

@end
