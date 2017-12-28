//
//  JCBMineTopTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBMineTopTVCell.h"
#import "JCBMineModel.h"

@implementation JCBMineTopTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(JCBMineModel *)model {
    _model = model;
    
    if (model.ableMoney == 0) {
        self.profitLabel.text = @"0.00";
    } else {
        self.profitLabel.text = [NSString stringWithFormat:@"%.2f", [model.ableMoney floatValue]];
    }
    
    NSString *userName = model.username;
    userName = [userName SG_replaceCharcterInRange:NSMakeRange(3, 4) withCharcter:@"****"];
    self.nameLabel.text = userName;

}


@end
