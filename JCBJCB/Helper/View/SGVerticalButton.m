//
//  SGVerticalButton.m
//  BSBDJ
//
//  Created by 杜露乾 on 16/6/22.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGVerticalButton.h"

@implementation SGVerticalButton

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.SG_y = self.SG_height * 0.2;
    self.imageView.SG_centerX = self.SG_width * 0.5;
    
    // 调整文字
    self.titleLabel.SG_x = 0;
    self.titleLabel.SG_y = self.imageView.SG_bottom;
    self.titleLabel.SG_height = self.SG_height - self.titleLabel.SG_y;
    self.titleLabel.SG_width = self.SG_width;
    
}

@end
