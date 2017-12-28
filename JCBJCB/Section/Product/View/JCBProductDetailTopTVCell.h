//
//  JCBProductDetailTopTVCell.h
//  JCBJCB
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBProductDetailModel;

@interface JCBProductDetailTopTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *title_label;

@property (weak, nonatomic) IBOutlet UILabel *income_label;
@property (weak, nonatomic) IBOutlet UIButton *income_button;
// 起投金额
@property (weak, nonatomic) IBOutlet UILabel *theSumOfMoney;
// 项目期限
@property (weak, nonatomic) IBOutlet UILabel *project_term;
@property (weak, nonatomic) IBOutlet UILabel *limitBuy_label;
@property (weak, nonatomic) IBOutlet UILabel *allInvestmentAmount;
@property (weak, nonatomic) IBOutlet UILabel *residulAmountOfI;


@property (nonatomic, strong) JCBProductDetailModel *model;

@end
