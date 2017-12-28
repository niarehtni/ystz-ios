//
//  JCBRewardTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRewardTVCell.h"
#import "JCBRewardModel.h"

@interface JCBRewardTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardType;

@end

@implementation JCBRewardTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JCBRewardModel *)model {
    _model = model;
    
    self.nameLabel.text = model.remark;
    
    NSString *money = [NSString stringWithFormat:@"+%@元", model.money];
    self.moneyLabel.text = money;
    
    NSString *endTime = [NSString stringWithFormat:@"%@", model.createDate];
    endTime = [endTime SG_transformationTimeFormatWithTime:endTime];
    endTime = [NSString stringWithFormat:@"%@", endTime];
    self.timeLabel.text = endTime;
    
    NSString *expDate = [NSString stringWithFormat:@"%@", model.typeShow];
    self.rewardType.text = expDate;
    
}


// 重写frame修改cell大小
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    // 在上面修改frame， 外界无法修改控件的frame
    [super setFrame:frame];
}


@end
