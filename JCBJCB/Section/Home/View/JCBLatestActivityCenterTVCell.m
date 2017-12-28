//
//  JCBLatestActivityCenterTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBLatestActivityCenterTVCell.h"
#import "JCBLatestActivityCenterModel.h"

@interface JCBLatestActivityCenterTVCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@end

@implementation JCBLatestActivityCenterTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(JCBLatestActivityCenterModel *)model {
    _model = model;
    
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile%@",SGCommonImageURL, model.imgApp]] placeholderImage:[UIImage imageNamed:@"palceholder_icon"]];
    self.nameLabel.text = model.title;
    
    NSString *time = [NSString stringWithFormat:@"%@", model.startTime];
    time = [time SG_transformationTimeFormatWithYMDTime:[NSString stringWithFormat:@"%@", model.startTime]];
    self.timeLabel.text = time;
    
    
    //NSString *currentDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if ([model.status isEqualToString:@"2"]) { // 2 已结束； 1 进行中
        self.smallImageView.image = [UIImage imageNamed:@"jcb_end_icon"];
    } else {
        self.smallImageView.image = [UIImage imageNamed:@"jcb_haveInHand_icon"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 重写frame修改cell大小
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += SGMargin;
    frame.size.height -= SGMargin;
    
    // 在上面修改frame， 外界无法修改控件的frame
    [super setFrame:frame];
}


@end
