//
//  JCBInvestmentSummaryTVC.m
//  JCBJCB
//
//  Created by apple on 17/1/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBInvestmentSummaryTVC.h"

@implementation JCBInvestmentSummaryTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.left_title.textColor = SGColorWithDarkGrey;
    self.right_label.textColor = SGrayColor(50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
