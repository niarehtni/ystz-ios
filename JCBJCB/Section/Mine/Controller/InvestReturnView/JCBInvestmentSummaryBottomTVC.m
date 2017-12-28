//
//  JCBInvestmentSummaryBottomTVC.m
//  JCBJCB
//
//  Created by apple on 17/1/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBInvestmentSummaryBottomTVC.h"
#import "JCBInvestmentSummary.h"

@interface JCBInvestmentSummaryBottomTVC ()
@property (weak, nonatomic) IBOutlet UILabel *left_label;
@property (weak, nonatomic) IBOutlet UILabel *center_label;
@property (weak, nonatomic) IBOutlet UILabel *right_label;

@end

@implementation JCBInvestmentSummaryBottomTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.left_label.textColor = SGColorWithDarkGrey;
    self.center_label.textColor = SGColorWithDarkGrey;
    self.right_label.textColor = SGColorWithDarkGrey;
}

- (void)setModel:(JCBInvestmentSummary *)model {
    _model = model;
    
    self.left_label.text = model.repaymentDate;
    self.center_label.text = [NSString stringWithFormat:@"%.2f", [model.waitInterest floatValue]];;
    self.right_label.text = [NSString stringWithFormat:@"%.2f", [model.waitAccount floatValue]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
