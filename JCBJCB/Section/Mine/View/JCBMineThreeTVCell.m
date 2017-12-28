//
//  JCBMineThreeTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBMineThreeTVCell.h"

@interface JCBMineThreeTVCell ()

@end

@implementation JCBMineThreeTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.smallDot.hidden = YES;
    [SGSmallTool SG_smallWithThisView:_smallDot cornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
