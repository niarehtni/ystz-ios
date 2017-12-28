//
//  JCBLatestActivityCenterModel.h
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBLatestActivityCenterModel : JCBModel

/** id */
@property(nonatomic, copy) NSString *ID;
/** orderList */
@property(nonatomic, copy) NSString *orderList;
/** createDate */
@property(nonatomic, copy) NSString *createDate;
/** modifyDate */
@property(nonatomic, copy) NSString *modifyDate;
/** title */
@property(nonatomic, copy) NSString *title;
/** imgWeb */
@property(nonatomic, copy) NSString *imgWeb;
/** imgApp */
@property(nonatomic, copy) NSString *imgApp;
/** endTime */
@property(nonatomic, copy) NSString *endTime;
/** array */
@property(nonatomic, copy) NSString *array;
/** startTime */
@property(nonatomic, copy) NSString *startTime;
/** status */
@property(nonatomic, copy) NSString *status;
/** content */
@property(nonatomic, copy) NSString *content;


@end
