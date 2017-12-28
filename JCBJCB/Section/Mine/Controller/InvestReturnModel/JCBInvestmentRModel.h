//
//  JCBInvestmentRModel.h
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBInvestmentRModel : JCBModel

/** borrowAccount */
@property (nonatomic, copy) NSString *borrowAccount;
/** tenderAccount */
@property (nonatomic, copy) NSString *tenderAccount;
/** borrowName */
@property (nonatomic, copy) NSString *borrowName;
/** borrowStatus */
@property (nonatomic, copy) NSString *borrowStatus;
/** apr */
@property (nonatomic, copy) NSString *apr;
/** createDate */
@property (nonatomic, copy) NSString *createDate;
/** borrowStatusShow */
@property (nonatomic, copy) NSString *borrowStatusShow;
/** interest */
@property (nonatomic, copy) NSString *interest;

/** tenderid */
@property (nonatomic, copy) NSString *tenderid;

@end
