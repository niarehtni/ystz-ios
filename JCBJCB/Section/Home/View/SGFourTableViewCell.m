//
//  SGFourTableViewCell.m
//  RongXunTechnology
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 RongXun. All rights reserved.
//

#import "SGFourTableViewCell.h"
#import "JCBFourCellModel.h"

@implementation SGFourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.pushProductVCBtn setTitleColor:SGColorWithDarkGrey forState:(UIControlStateNormal)];
    self.pushProductVCBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];

    self.dot_view.layer.cornerRadius = 4;
    self.dot_view.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JCBFourCellModel *)model {
    _model = model;
    
    self.name_label.text = model.name;
    self.baseApr_label.text = [NSString stringWithFormat:@"%.2f", model.baseApr];
    // 新手优惠
    if (model.awardApr == 0) {
        self.awardApr_label.hidden = YES;
    } else {
        self.awardApr_label.hidden = NO;
    }
    [self.awardApr_label setTitle:[NSString stringWithFormat:@" + %.2f%%", model.awardApr] forState:(UIControlStateNormal)];
    // cell.awardApr_label.titleLabel.text = [NSString stringWithFormat:@" + %.2f", model.awardApr];
    self.timeLimit_label.text = [NSString stringWithFormat:@"%zd天", model.timeLimit];
    self.account_label.text = [NSString stringWithFormat:@"%zd元", model.account];
    self.balance_Label.text = [NSString stringWithFormat:@"%zd元", model.balance];
}

@end
