//
//  JCBProductDNLeftTVThreeCell.h
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBProjectDescriptionModel;

@interface JCBProductDNLeftTVThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum_label;
@property (weak, nonatomic) IBOutlet UILabel *repaymentDateInt_label;
@property (weak, nonatomic) IBOutlet UILabel *account_label;
@property (weak, nonatomic) IBOutlet UILabel *capital_label;
@property (weak, nonatomic) IBOutlet UILabel *interest_label;

@property (nonatomic, strong) JCBProjectDescriptionModel *model;
@end
