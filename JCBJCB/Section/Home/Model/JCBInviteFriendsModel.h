//
//  JCBInviteFriendsModel.h
//  JCBJCB
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBInviteFriendsModel : JCBModel
/** id */
@property (nonatomic, copy) NSString *id;
/** uadSumMoney */
@property (nonatomic, copy) NSString *uadSumMoney;
/** realStatus */
@property (nonatomic, copy) NSString *realStatus;
/** username */
@property (nonatomic, copy) NSString *username;
/** bdSumMoney */
@property (nonatomic, copy) NSString *bdSumMoney;
/** createDate */
@property (nonatomic, copy) NSString *createDate;
/** emailStatus */
@property (nonatomic, copy) NSString *emailStatus;

@end
