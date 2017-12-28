//
//  JCBRechargeCashTVCell.h
//  JCBJCB
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBRechargeCashModel;

@interface JCBRechargeCashTVCell : UITableViewCell

@property (nonatomic, strong) JCBRechargeCashModel *rechargeRecordModel;
@property (nonatomic, strong) JCBRechargeCashModel *presentRecordModel;

@end
