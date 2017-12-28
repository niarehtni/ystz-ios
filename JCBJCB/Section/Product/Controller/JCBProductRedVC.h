//
//  JCBProductRedVC.h
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *);
typedef void(^ArrBlock)(NSString *);
typedef void(^NewMoney)(NSString *);

@interface JCBProductRedVC : UIViewController
@property (nonatomic, copy) NSString *bidMoneyStr;
@property (nonatomic, copy) NSString *bidIDStr;
/** 剩余可投金额 */
@property (nonatomic, copy) NSString *surplus_money;
/** 用于传值 */
@property (copy, nonatomic) MyBlock valueStr;

/** 红包ID用于传值 */
@property (copy, nonatomic) ArrBlock valueArr;

/** 超出红包使用的金钱数 */
@property (copy, nonatomic) NewMoney newMoney;

@end
