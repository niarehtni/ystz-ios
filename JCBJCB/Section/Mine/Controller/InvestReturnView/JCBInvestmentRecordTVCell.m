//
//  JCBInvestmentRecordTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBInvestmentRecordTVCell.h"
#import "JCBInvestmentRModel.h"

@interface JCBInvestmentRecordTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showTypeImageView;

@end

@implementation JCBInvestmentRecordTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(JCBInvestmentRModel *)model {
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.borrowName];
    
    // 判断项目状态
    if ([model.borrowStatusShow isEqualToString:@"已还完"]) {
        self.showTypeImageView.image = [UIImage imageNamed:@"mine_investment_end_icon"];
    } else {
        self.showTypeImageView.image = [UIImage imageNamed:@"mine_investment_icon"];
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [model.tenderAccount floatValue]];
    
    NSString *time = [NSString stringWithFormat:@"%@", model.createDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%@", model.createDate]];
    self.createDateLabel.text = time;
    
    if (model.interest == nil) {
        self.getMoneyLabel.text = @"+0.00";
    } else {
        self.getMoneyLabel.text = [NSString stringWithFormat:@"+%@", model.interest];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
