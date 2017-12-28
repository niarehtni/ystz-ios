//
//  JCBPayBackTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBPayBackTVCell.h"
#import "JCBPayBackModel.h"

@interface JCBPayBackTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation JCBPayBackTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(JCBPayBackModel *)model {
    _model = model;
    
    self.nameLabel.text = model.borrowName;
    self.moneyLabel.text = model.waitTotal;
    
    NSString *time = [NSString stringWithFormat:@"%@", model.repaymentDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%@", model.repaymentDate]];
    self.timeLabel.text = time;
    
    
    self.typeLabel.text = @"回款金额";
}


- (void)setBackModel:(JCBPayBackModel *)backModel {
    _backModel = backModel;
    
    self.nameLabel.text = backModel.borrowName;
    self.moneyLabel.text = backModel.waitTotal;
    
    NSString *time = [NSString stringWithFormat:@"%@", backModel.repaymentDate];
    time = [time SG_transformationTimeFormatWithTime:[NSString stringWithFormat:@"%@", backModel.repaymentDate]];
    self.timeLabel.text = time;
    
    
    self.typeLabel.text = @"回款金额";
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


@end
