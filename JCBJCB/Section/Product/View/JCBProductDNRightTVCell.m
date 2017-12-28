//
//  JCBProductDNRightTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDNRightTVCell.h"
#import "JCBInvestmentRecordModel.h"

@implementation JCBProductDNRightTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(JCBInvestmentRecordModel *)model {
    _model = model;
    
    self.phoneNumber_label.text = model.username;
    NSString *time = [NSString stringWithFormat:@"%f", model.createDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%f", model.createDate]];
    self.time_label.text = time;
    self.money_label.text = [NSString stringWithFormat:@"%.2f", model.money];
}


@end
