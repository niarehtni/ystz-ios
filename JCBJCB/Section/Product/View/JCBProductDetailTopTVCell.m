//
//  JCBProductDetailTopTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailTopTVCell.h"
#import "JCBProductDetailModel.h"

@implementation JCBProductDetailTopTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JCBProductDetailModel *)model {
    _model = model;
    
    self.title_label.text = model.name;
    
    // 年化收益
    self.income_label.text = [NSString stringWithFormat:@"%.2f", model.baseApr];
    
    // 新手优惠
    if (model.awardApr == 0) {
        self.income_button.hidden = YES;
    } else {
        self.income_button.hidden = NO;
    }
    [self.income_button setTitle:[NSString stringWithFormat:@"  + %.2f%%", model.awardApr] forState:(UIControlStateNormal)];
    
    
    // 投资时间
    self.project_term.text = [NSString stringWithFormat:@"%@天", model.timeLimit];
    // 最低起投金额
    self.theSumOfMoney.text = [NSString stringWithFormat:@"%@元", model.lowestAccount];
    
    // 投资总金额
    NSString *account = nil;
    if (model.account < 10000) {
        account = [NSString stringWithFormat:@"%zd", model.account];
    } else {
        account = [NSString stringWithFormat:@"%.1f万元", model.account / 10000.0];
    }
    self.allInvestmentAmount.text = account;
    
    // 剩余可投金额
    NSString *balance = nil;
    if (model.balance < 10000) {
        balance = [NSString stringWithFormat:@"%zd元", model.balance];
    } else {
        balance = [NSString stringWithFormat:@"%.1f万元", model.balance / 10000.0];
    }
    self.residulAmountOfI.text = balance;

    // 限购
    if ([model.mostAccount isEqualToString:@""]) {
        self.limitBuy_label.text = @"";
    } else {
        self.limitBuy_label.text = [NSString stringWithFormat:@"限购：¥%@", model.mostAccount];
    }
    
}

@end
