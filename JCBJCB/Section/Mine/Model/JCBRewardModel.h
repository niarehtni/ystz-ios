//
//  JCBRewardModel.h
//  JCBJCB
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBRewardModel : JCBModel

/** money */
@property (nonatomic, copy) NSString *money;
/** createDate */
@property (nonatomic, copy) NSString *createDate;
/** remark */
@property (nonatomic, copy) NSString *remark;
/** type */
@property (nonatomic, copy) NSString *type;
/** typeShow */
@property (nonatomic, copy) NSString *typeShow;

@end
