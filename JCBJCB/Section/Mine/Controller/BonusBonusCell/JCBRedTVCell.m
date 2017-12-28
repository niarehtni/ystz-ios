//
//  JCBRedTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRedTVCell.h"
#import "JCBRedModel.h"

@interface JCBRedTVCell ()
@property (weak, nonatomic) IBOutlet UIImageView *redImageView;

@property (weak, nonatomic) IBOutlet UILabel *sourceStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentADLabel;
@property (weak, nonatomic) IBOutlet UILabel *redMoneyLabel;

@end

@implementation JCBRedTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // _redMoneyLabel.textColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JCBRedModel *)model {
    _model = model;
    
    // 判断红包图片的状态
    if ([model.status isEqualToString:@"0"]) {
        self.redImageView.image = [UIImage imageNamed:@"product_red_bg_icon"];
        _redMoneyLabel.textColor = [UIColor yellowColor];
    } else {
        self.redImageView.image = [UIImage imageNamed:@"product_used_red_bg_icon"];
        _redMoneyLabel.textColor = SGColorWithDarkGrey;
    }
    
    self.sourceStringLabel.text = model.name;
    
    NSString *endTime = [NSString stringWithFormat:@"%@", model.endTime];
    endTime = [endTime SG_transformationTimeFormatWithYMDTime:endTime];
    endTime = [NSString stringWithFormat:@"(%@ 到期)", endTime];
    self.dueTimeLabel.text = endTime;
    
    NSString *expDate = [NSString stringWithFormat:@"项目期限：满%@天可用", model.limitStart];
    self.projectDurationLabel.text = expDate;
    
    NSString *money = [NSString stringWithFormat:@"项目金额：满%@元可用", model.investFullMomey];
    self.investmentADLabel.text = money;
    
    NSString *redMoney = [NSString stringWithFormat:@"%@元", model.money];
    self.redMoneyLabel.text = redMoney;
}


// 重写frame修改cell大小
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    // 在上面修改frame， 外界无法修改控件的frame
    [super setFrame:frame];
}


@end
