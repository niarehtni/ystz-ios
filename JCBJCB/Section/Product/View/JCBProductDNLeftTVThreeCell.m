//
//  JCBProductDNLeftTVThreeCell.m
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDNLeftTVThreeCell.h"
#import "JCBProjectDescriptionModel.h"

@implementation JCBProductDNLeftTVThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JCBProjectDescriptionModel *)model {
    _model = model;
    
    self.orderNum_label.text = model.orderNum;
    self.repaymentDateInt_label.text = [NSString stringWithFormat:@"第%@天", model.repaymentDateInt];
    self.account_label.text = [NSString stringWithFormat:@"%.f", model.account ]; //
    self.capital_label.text = [NSString stringWithFormat:@"%.f", model.capital]; // 还款本息
    self.interest_label.text = [NSString stringWithFormat:@"%.2f", model.interest]; //
}



@end

