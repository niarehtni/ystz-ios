//
//  JCBFundRecordTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBFundRecordTVCell.h"
#import "JCBFundRecordModel.h"

@implementation JCBFundRecordTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



// 重写frame修改cell大小
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    // 在上面修改frame， 外界无法修改控件的frame
    [super setFrame:frame];
}


- (void)setModel:(JCBFundRecordModel *)model {
    _model = model;
    
    self.typeShowLabel.text = model.typeShow;
    NSString *time = [NSString stringWithFormat:@"%f", model.createDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%f", model.createDate]];
    self.createDateLabel.text = time;
    
    self.ableMoneyLabel.text = model.ableMoney;
    if (model.sign == 1) {
        self.moneyLabel.textColor = SGColorWithRGB(95, 184, 253);
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", model.money];
    } else {
        self.moneyLabel.textColor = SGColorWithRed;
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", model.money];
    }
    
}


@end
