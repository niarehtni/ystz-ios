//
//  JCBRechargeCashModel.h
//  JCBJCB
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBRechargeCashModel : JCBModel
// 提现记录
/** id */
@property (nonatomic, copy) NSString *id;
/** name */
@property (nonatomic, copy) NSString *name;
/** money */
@property (nonatomic, copy) NSString *money;
/** createDate */
@property (nonatomic, copy) NSString *createDate;
/** status */
@property (nonatomic, copy) NSString *status;
/** rechargeShow */
@property (nonatomic, copy) NSString *rechargeShow;

// 充值记录
/** rechargeDate */
@property (nonatomic, copy) NSString *rechargeDate;
/** cardNo */
@property (nonatomic, copy) NSString *cardNo;
/** bankName */
@property (nonatomic, copy) NSString *bankName;
/** branch */
@property (nonatomic, copy) NSString *branch;
/** cardFour */
@property (nonatomic, copy) NSString *cardFour;
/** statusShow */
@property (nonatomic, copy) NSString *statusShow;
/** fee */
@property (nonatomic, copy) NSString *fee;


/** rechargeInterfaceId */
@property (nonatomic, copy) NSString *rechargeInterfaceId;
/** type */
@property (nonatomic, copy) NSString *type;
/** reward */
@property (nonatomic, copy) NSString *reward;
/** tradeNo */
@property (nonatomic, copy) NSString *tradeNo;


@end
