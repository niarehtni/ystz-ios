//
//  JCBFundRecordTVCell.h
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBFundRecordModel;

@interface JCBFundRecordTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ableMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@property (nonatomic, strong) JCBFundRecordModel *model;

@end
