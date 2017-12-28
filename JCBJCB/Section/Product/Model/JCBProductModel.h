//
//  JCBProductModel.h
//  JCBJCB
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBProductModel : JCBModel
@property(nonatomic,strong) NSString *ID;
// 标题
@property (nonatomic, copy) NSString *name;
// 年化收益
@property (nonatomic, assign) CGFloat baseApr;
// 新手优惠百分比
@property (nonatomic, assign) CGFloat awardApr;
// 投资期限
@property (nonatomic, copy) NSString *timeLimit;
// 起投金额
@property (nonatomic, copy) NSString *lowestAccount;
// 剩余金额
@property (nonatomic, copy) NSString *balance;
// 进度条
@property (nonatomic, assign) CGFloat schedule;
//标类型（14：天标；16：新手标）
@property (nonatomic, copy) NSString *type;

@end
