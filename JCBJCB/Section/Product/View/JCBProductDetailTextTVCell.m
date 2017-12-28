//
//  JCBProductDetailTextTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailTextTVCell.h"

@interface JCBProductDetailTextTVCell ()
@property (weak, nonatomic) IBOutlet UIButton *text_Button;

@end

@implementation JCBProductDetailTextTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.text_Button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.text_Button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
