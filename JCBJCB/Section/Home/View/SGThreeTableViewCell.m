//
//  SGThreeTableViewCell.m
//  RongXunTechnology
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 RongXun. All rights reserved.
//

#import "SGThreeTableViewCell.h"

@implementation SGThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.left_imageView = [[UIImageView alloc] init];
    _left_imageView.image = [UIImage imageNamed:@"latest_activities"];
    [self.contentView addSubview:_left_imageView];
    
    self.bg_view = [[UIView alloc] init];
    //self.bg_view.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_bg_view];
    
    self.detail_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_detail_btn setTitle:@"详情" forState:(UIControlStateNormal)];
    _detail_btn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    [_detail_btn setTitleColor:SGColorWithDarkGrey forState:(UIControlStateNormal)];
    [_detail_btn setImage:[UIImage imageNamed:@"jcb_more"] forState:(UIControlStateNormal)];
    _detail_btn.titleEdgeInsets = UIEdgeInsetsMake(0, - SGMargin, 0, 0);
    _detail_btn.imageEdgeInsets = UIEdgeInsetsMake(0, 4 * SGMargin, 0, 0);
    //_detail_btn.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_detail_btn];
    
    self.title_label = [[UILabel alloc] init];
    //_title_label.backgroundColor = [UIColor brownColor];
    _title_label.font = [UIFont systemFontOfSize:SGTextFontWith13];
    [self.bg_view addSubview:_title_label];
    
    self.activityTime_label = [[UILabel alloc] init];
    _activityTime_label.font = [UIFont systemFontOfSize:SGTextFontWith11];
    _activityTime_label.textColor = SGColorWithBlackOfDark;
    [self.bg_view addSubview:_activityTime_label];
    
    self.smallIcon_imageView = [[UIImageView alloc] init];
    _smallIcon_imageView.image = [UIImage imageNamed:@"jcb_hot_icon"];
    [self.bg_view addSubview:_smallIcon_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left_imageViewX = 0;
    CGFloat left_imageViewY = 0;
    CGFloat left_imageViewH = self.frame.size.height;
    CGFloat left_imageViewW = _left_imageView.image.size.width / _left_imageView.image.size.height * left_imageViewH;
    _left_imageView.frame = CGRectMake(left_imageViewX, left_imageViewY, left_imageViewW, left_imageViewH);
    
    CGFloat detail_btnX = SG_screenWidth - 5 * SGMargin - SGSmallMargin;
    CGFloat detail_btnY = 0;
    CGFloat detail_btnW = 5 * SGMargin;
    CGFloat detail_btnH = 30;
    _detail_btn.frame = CGRectMake(detail_btnX, detail_btnY, detail_btnW, detail_btnH);
    
    CGFloat bg_viewX = CGRectGetMaxX(_left_imageView.frame) + SGSmallMargin;
    CGFloat bg_viewY = SGSmallMargin;
    CGFloat bg_viewW = SG_screenWidth - detail_btnW - SGSmallMargin - bg_viewX;
    CGFloat bg_viewH = self.frame.size.height - 2 * bg_viewY;
    _bg_view.frame = CGRectMake(bg_viewX, bg_viewY, bg_viewW, bg_viewH);
    
    CGFloat activityTime_labelX = 0;
    CGFloat activityTime_labelY = 0.5 * bg_viewH;
    CGSize activityTime_labelSize = [SGHelperTool SG_sizeWithText:_activityTime_label.text font:[UIFont systemFontOfSize:SGTextFontWith11] maxSize:CGSizeMake(CGFLOAT_MAX, bg_viewH)];
    CGFloat activityTime_labelH = 0.5 * bg_viewH;
    _activityTime_label.frame = CGRectMake(activityTime_labelX, activityTime_labelY, activityTime_labelSize.width, activityTime_labelH);

    CGFloat title_labelW;
    NSString *title_label_text = _title_label.text;
    CGSize title_labelSize = [SGHelperTool SG_sizeWithText:title_label_text font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(CGFLOAT_MAX, 0.5 * bg_viewH)];
    if (iphone4s || iphone5s) {
        if (title_label_text.length > 9) {
            title_labelW = 120;
        } else {
            title_labelW = title_labelSize.width;
        }
    } else {
        title_labelW = title_labelSize.width;
    }
    CGFloat title_labelX = 0;
    CGFloat title_labelY = 0;
    CGFloat title_labelH = 0.5 * bg_viewH;
    _title_label.frame = CGRectMake(title_labelX, title_labelY, title_labelW, title_labelH);
    
    CGFloat smallIcon_imageViewX = CGRectGetMaxX(_title_label.frame) + SGSmallMargin;
    CGFloat smallIcon_imageViewW = _smallIcon_imageView.image.size.width;
    CGFloat smallIcon_imageViewH = _smallIcon_imageView.image.size.height;
    CGFloat smallIcon_imageViewY = 0.5 * (title_labelH - smallIcon_imageViewH);
    _smallIcon_imageView.frame = CGRectMake(smallIcon_imageViewX, smallIcon_imageViewY, smallIcon_imageViewW, smallIcon_imageViewH);
}

@end
