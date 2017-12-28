//
//  JCBRechargeCashTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRechargeCashTVCell.h"
#import "JCBRechargeCashModel.h"

@interface JCBRechargeCashTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation JCBRechargeCashTVCell

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

// 充值记录
- (void)setRechargeRecordModel:(JCBRechargeCashModel *)rechargeRecordModel {
    _rechargeRecordModel = rechargeRecordModel;
    
    self.nameLabel.text = rechargeRecordModel.name;
    self.moneyLabel.text = rechargeRecordModel.money;
    
    NSString *time = [NSString stringWithFormat:@"%@", rechargeRecordModel.createDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%@", rechargeRecordModel.createDate]];
    self.createDateLabel.text = time;
    
    if ([rechargeRecordModel.status integerValue] == 1) {
        self.statusLabel.text = [NSString stringWithFormat:@"充值%@", rechargeRecordModel.statusShow];
    } else if ([rechargeRecordModel.status integerValue] == 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"充值%@", rechargeRecordModel.statusShow];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@", rechargeRecordModel.statusShow];
    }
    
}


// 提现记录
- (void)setPresentRecordModel:(JCBRechargeCashModel *)presentRecordModel {
    _presentRecordModel = presentRecordModel;
    
    NSString *cardNoStr = [NSString stringWithFormat:@"%@", presentRecordModel.cardNo];
    NSString *lastFourCardNo = [cardNoStr substringFromIndex:cardNoStr.length - 4];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ (尾号为：%@)", presentRecordModel.bankName, lastFourCardNo];
    
    self.moneyLabel.text = presentRecordModel.money;

    NSString *time = [NSString stringWithFormat:@"%@", presentRecordModel.createDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%@", presentRecordModel.createDate]];
    self.createDateLabel.text = time;
    
    if ([presentRecordModel.status integerValue] == 1) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@", presentRecordModel.statusShow];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@", presentRecordModel.statusShow];
    }
}

@end


