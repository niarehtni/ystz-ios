//
//  SGFiveTableViewCell.m
//  RongXunTechnology
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 RongXun. All rights reserved.
//

#import "SGFiveTableViewCell.h"

@implementation SGFiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.quickInvite_btn.layer.cornerRadius = 5;
    self.quickInvite_btn.layer.masksToBounds = YES;
    
    self.redPacker_money.textColor = [UIColor redColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
