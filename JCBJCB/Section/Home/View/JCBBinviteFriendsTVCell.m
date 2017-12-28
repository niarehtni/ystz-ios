//
//  JCBBinviteFriendsTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBBinviteFriendsTVCell.h"
#import "JCBInviteFriendsModel.h"

@interface JCBBinviteFriendsTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation JCBBinviteFriendsTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.moneyLabel.textColor = SGColorWithRGB(129, 62, 21);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JCBInviteFriendsModel *)model {
    _model = model;
    
    self.usernameLabel.text = model.username;
    
    self.timeLabel.text = model.createDate;
    NSString *time = [NSString stringWithFormat:@"%@", model.createDate];
    time = [time SG_transformationTimeFormatWithYMDTime:[NSString stringWithFormat:@"%@", model.createDate]];
    self.timeLabel.text = time;
    
    if (model.uadSumMoney == nil) {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥0.00"];
    } else {
       self.moneyLabel.text = [NSString stringWithFormat:@"¥%@", model.uadSumMoney];
    }
    
}


@end
