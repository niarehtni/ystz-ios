//
//  JCBProductInvestModel.h
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBProductInvestModel : JCBModel
/** id */
@property (nonatomic, copy) NSString *ID;
/** name */
@property (nonatomic, copy) NSString *name;
/** 项目金额 */
@property (nonatomic, copy) NSString *account;
/** 年化收益 */
@property (nonatomic, assign) CGFloat yearApr;
/** 剩余金额 */
@property (nonatomic, copy) NSString *balance;
/** 理财期限 */
@property (nonatomic, copy) NSString *timeLimit;
/** 状态 showBorrowStatus = 募集中 */
@property (nonatomic, copy) NSString *showBorrowStatus;
/** 当前时间 */
@property (nonatomic, copy) NSString *currentDate;
/** 项目奖励红包 */
@property (nonatomic, copy) NSString *funds;
/** 最小投资额 */
@property (nonatomic, copy) NSString *lowestAccount;
/** 最大投资额 */
@property (nonatomic, copy) NSString *mostAccount;
/** 发布时间 */
@property (nonatomic, copy) NSString *verifyTime;
/** 进度 */
@property (nonatomic, copy) NSString *showSchedule;
/** 过期时间 */
@property (nonatomic, copy) NSString *overDate;
/** 判断会员的登录状态,0未登录,1已登录 */
@property (nonatomic, copy) NSString *userFlg;
/** 可用余额 */
@property (nonatomic, copy) NSString *userAbleMoney;
/** 用户的红包数组 */
@property (nonatomic, strong) NSArray *userHongbaoItem;
/** 可用红包的百分比 */
@property (nonatomic, copy) NSString *awardScale;
/** 基本收益 */
@property (nonatomic, copy) NSString *baseApr;
/** 奖励收益 */
@property (nonatomic, copy) NSString *awardApr;

/** 还款方式 styleName = 到期付本息 */
@property (nonatomic, copy) NSString *styleName;
/** 资金保障 */
@property (nonatomic, copy) NSString *NetWorkingEngine;

/** rcd */
@property (nonatomic, copy) NSString *rcd;
/** type */
@property (nonatomic, copy) NSString *type;
/** pwdFlg */
@property (nonatomic, copy) NSString *pwdFlg;
/** tasteMoney */
@property (nonatomic, copy) NSString *tasteMoney;
/** style */
@property (nonatomic, copy) NSString *style;
/** rmg */
@property (nonatomic, copy) NSString *rmg;
/** businessType */
@property (nonatomic, copy) NSString *businessType;
/** content */
@property (nonatomic, copy) NSString *content;
/** capitalEnsure = 本息担保 */
@property (nonatomic, copy) NSString *capitalEnsure;
/** status */
@property (nonatomic, copy) NSString *status;
/** realStatus */
@property (nonatomic, copy) NSString *realStatus;
/** businessCode */
@property (nonatomic, copy) NSString *businessCode;
/** borImage */
@property (nonatomic, strong) NSArray *borImage;

// borrowVerifyJson = {"anCase":"0","cardDriving":"0","gcfp":"0","gouZhi":"0","guJia":"0","household":"0","idCard":"0","income":"0","jdczs":"0","zhengXin":"0"},
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)JCBProductInvestWithDictionary:(NSDictionary *)dict;


@end
