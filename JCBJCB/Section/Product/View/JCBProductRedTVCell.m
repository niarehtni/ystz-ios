//
//  JCBProductRedTVCell.m
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductRedTVCell.h"
#import "JCBProductRedModel.h"

@interface JCBProductRedTVCell ()
@property (nonatomic , strong) UIView *bg_view; // 底部view
@property (nonatomic , strong) UIImageView *redImageView; // 红包imageView
@property (nonatomic , strong) UILabel *moneyLabel; // 红包上面的金钱数
@property (nonatomic , strong) UILabel *sourceStringLabel; // 红包来源
@property (nonatomic , strong) UILabel *endTimeLabel; // 红包到期时间
@property (nonatomic , strong) UILabel *limitStartLabel; // 红包满多少天使用
@property (nonatomic , strong) UILabel *investFullMomeyLabel; // 红包满多少元使用

@end

@implementation JCBProductRedTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //[self.selectedBtn setImage:[UIImage imageNamed:@"product_red_icon"] forState:UIControlStateNormal];
    //[self.selectedBtn setImage:[UIImage imageNamed:@"product_red_selected_icon"] forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// 底部view
- (UIView *)bg_view {
    if (_bg_view == nil) {
        self.bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, SGMargin, SG_screenWidth, redCellHeight - SGMargin)];
        self.bg_view.backgroundColor = SGColorWithWhite;
    }
    return _bg_view;
}


- (void)setupSubviews {
    // 红包imageView
    CGFloat redImageViewX = SGMargin + SGSmallMargin;
    CGFloat redImageViewY = SGMargin;
    CGFloat redImageViewW = self.bg_view.SG_height - 2 * redImageViewY;
    CGFloat redImageViewH = redImageViewW;
    self.redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(redImageViewX, redImageViewY, redImageViewW, redImageViewH)];
    _redImageView.image = [UIImage imageNamed:@"product_red_bg_icon"];
    [self.bg_view addSubview:_redImageView];
    
    // 红包上面的金钱数
    CGFloat moneyLabelW = redImageViewW;
    CGFloat moneyLabelH = 20;
    CGFloat moneyLabelX = 0;
    CGFloat moneyLabelY = redImageViewH - moneyLabelH - SGSmallMargin;
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabelX, moneyLabelY, moneyLabelW, moneyLabelH)];
    //_moneyLabel.backgroundColor = [UIColor brownColor];
    _moneyLabel.font = [UIFont systemFontOfSize:20];
    _moneyLabel.textColor = [UIColor yellowColor];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.redImageView addSubview:_moneyLabel];
    
    // button
    self.selectedBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"product_red_icon"] forState:(UIControlStateNormal)];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"product_red_selected_icon"] forState:(UIControlStateSelected)];
    CGFloat selectedBtnW = 30;
    CGFloat selectedBtnH = selectedBtnW;
    CGFloat selectedBtnX = SG_screenWidth - SGMargin - selectedBtnW;
    CGFloat selectedBtnY = (self.bg_view.SG_height - selectedBtnH) * 0.5;
    _selectedBtn.frame = CGRectMake(selectedBtnX, selectedBtnY, selectedBtnW, selectedBtnH);
    //_selectedBtn.backgroundColor = [UIColor yellowColor];
    [self.bg_view addSubview:_selectedBtn];
    
    // 红包来源
    CGFloat sourceStringLabelX = CGRectGetMaxX(self.redImageView.frame) + SGMargin;
    CGFloat sourceStringLabelY = SGMargin + 2;
    CGFloat sourceStringLabelW = SG_screenWidth - sourceStringLabelX - SGMargin * 10;
    CGFloat sourceStringLabelH = 18;
    self.sourceStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(sourceStringLabelX, sourceStringLabelY, sourceStringLabelW, sourceStringLabelH)];
    //_sourceStringLabel.backgroundColor = [UIColor yellowColor];
    _sourceStringLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [self.bg_view addSubview:_sourceStringLabel];
    
    CGFloat threeLabelHeight = self.bg_view.SG_height - CGRectGetMaxY(self.sourceStringLabel.frame) - sourceStringLabelY;
    
    // 红包到期时间
    CGFloat endTimeLabelX = CGRectGetMaxX(self.redImageView.frame) + SGMargin;
    CGFloat endTimeLabelY = CGRectGetMaxY(self.sourceStringLabel.frame) + 2;
    CGFloat endTimeLabelW = SG_screenWidth - endTimeLabelX - SGMargin;
    CGFloat endTimeLabelH = threeLabelHeight / 3;
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(endTimeLabelX, endTimeLabelY, endTimeLabelW, endTimeLabelH)];
    //_endTimeLabel.backgroundColor = [UIColor redColor];
    _endTimeLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    _endTimeLabel.textColor = SGColorWithBlackOfDark;
    [self.bg_view addSubview:_endTimeLabel];
    
    // 红包满多少天使用
    CGFloat limitStartLabelX = CGRectGetMaxX(self.redImageView.frame) + SGMargin;
    CGFloat limitStartLabelY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGFloat limitStartLabelW = SG_screenWidth - limitStartLabelX - SGMargin;
    CGFloat limitStartLabelH = threeLabelHeight / 3;
    self.limitStartLabel = [[UILabel alloc] initWithFrame:CGRectMake(limitStartLabelX, limitStartLabelY, limitStartLabelW, limitStartLabelH)];
    //_limitStartLabel.backgroundColor = [UIColor redColor];
    _limitStartLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    _limitStartLabel.textColor = SGColorWithBlackOfDark;
    [self.bg_view addSubview:_limitStartLabel];
    
    // 红包满多少元使用
    CGFloat investFullMomeyLabelX = CGRectGetMaxX(self.redImageView.frame) + SGMargin;
    CGFloat investFullMomeyLabelY = CGRectGetMaxY(self.limitStartLabel.frame);
    CGFloat investFullMomeyLabelW = SG_screenWidth - investFullMomeyLabelX - SGMargin;
    CGFloat investFullMomeyLabelH = threeLabelHeight / 3;
    self.investFullMomeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(investFullMomeyLabelX, investFullMomeyLabelY, investFullMomeyLabelW, investFullMomeyLabelH)];
    // _investFullMomeyLabel.backgroundColor = [UIColor redColor];
    _investFullMomeyLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    _investFullMomeyLabel.textColor = SGColorWithBlackOfDark;
    [self.bg_view addSubview:_investFullMomeyLabel];
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.bg_view];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setModel:(JCBProductRedModel *)model {
    _model = model;
    
    _selectedBtn.selected = model.isSelected;
    
    // 红包名称
    self.sourceStringLabel.text = model.name;
    
    // 红包钱数
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元", model.money];
    
    NSString *endTime = [NSString stringWithFormat:@"%@", model.endTime];
    endTime = [endTime SG_transformationTimeFormatWithYMDTime:endTime];
    endTime = [NSString stringWithFormat:@"(%@ 到期)", endTime];
    self.endTimeLabel.text = endTime;
    
    NSString *expDate = [NSString stringWithFormat:@"项目期限：满%@天可用", model.limitStart];
    self.limitStartLabel.text = expDate;
    
    NSString *money = [NSString stringWithFormat:@"项目金额：满%@元可用", model.investFullMomey];
    self.investFullMomeyLabel.text = money;
}

- (void)setUnUseModel:(JCBProductRedModel *)unUseModel {
    _unUseModel = unUseModel;
    
    _selectedBtn.selected = unUseModel.isSelected;

    // 红包名称
    self.sourceStringLabel.text = unUseModel.name;
    
    // 红包钱数
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元", unUseModel.money];
    
    NSString *endTime = [NSString stringWithFormat:@"%@", unUseModel.endTime];
    endTime = [endTime SG_transformationTimeFormatWithYMDTime:endTime];
    endTime = [NSString stringWithFormat:@"(%@ 到期)", endTime];
    self.endTimeLabel.text = endTime;
    
    NSString *expDate = [NSString stringWithFormat:@"项目期限：满%@天可用", unUseModel.limitStart];
    self.limitStartLabel.text = expDate;
    
    NSString *money = [NSString stringWithFormat:@"项目金额：满%@元可用", unUseModel.investFullMomey];
    self.investFullMomeyLabel.text = money;
}



@end



