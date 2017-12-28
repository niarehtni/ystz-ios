//
//  JCBFundRecordModel.h
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBFundRecordModel : JCBModel

/** typeShow */
@property (nonatomic, copy) NSString *typeShow;

/** createDate */
@property (nonatomic, assign) CGFloat createDate;

/** ableMoney */
@property (nonatomic, copy) NSString *ableMoney;

/** money */
@property (nonatomic, assign) CGFloat money;



/** type */
@property (nonatomic, copy) NSString *type;


/** tasteMoney */
@property (nonatomic, assign) CGFloat tasteMoney;


/** sign */
@property (nonatomic, assign) CGFloat sign;

/** remark */
@property (nonatomic, copy) NSString *remark;

@end
