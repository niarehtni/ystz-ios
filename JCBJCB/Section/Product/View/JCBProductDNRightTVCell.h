//
//  JCBProductDNRightTVCell.h
//  JCBJCB
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBInvestmentRecordModel;

@interface JCBProductDNRightTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *money_label;

@property (nonatomic, strong) JCBInvestmentRecordModel *model;

@end
