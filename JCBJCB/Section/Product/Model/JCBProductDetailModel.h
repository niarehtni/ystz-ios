//
//  JCBProductDetailModel.h
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBProductDetailModel : JCBModel

// type 标类型  16 新手标
@property (nonatomic, assign) CGFloat type;
// 标题
@property (nonatomic, copy) NSString *name_detail;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mostAccount;
// 年化收益
@property (nonatomic, assign) CGFloat baseApr;
// 新手优惠百分比
@property (nonatomic, assign) CGFloat awardApr;
// 投资期限
@property (nonatomic, copy) NSString *timeLimit;
// 起投金额
@property (nonatomic, copy) NSString *lowestAccount;
// 总金额
@property (nonatomic, assign) NSInteger account;
// 剩余可投金额
@property (nonatomic, assign) NSInteger balance;
// 进度条
@property (nonatomic, assign) CGFloat schedule;


// 资金保障
@property (nonatomic, copy) NSString *capitalEnsure;
// 还款方式
@property (nonatomic, copy) NSString *styleName;

// 发布时间
@property (nonatomic, assign) CGFloat verifyTime;
// 当前时间
@property (nonatomic, assign) CGFloat currentDate;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
