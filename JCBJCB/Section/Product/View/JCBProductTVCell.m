//
//  JCBProductTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductTVCell.h"
#import "JCBProductModel.h"

@implementation JCBProductTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.progressView showPopUpViewAnimated:YES];
    self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:15];
    self.progressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor redColor], [UIColor redColor]];
}

- (void)setModel:(JCBProductModel *)model {
    _model = model;
    
    // 标题
    self.title_label.text = model.name;
    
    // 年化收益
    self.baseApr_label.text = [NSString stringWithFormat:@"%.2f%%", model.baseApr];

    // 新手优惠
    if ([model.type isEqualToString:@"16"]) {

        if (model.schedule == 100) {
            self.noviceSign_imageV.hidden = NO;
            self.noviceSign_imageV.image = [UIImage imageNamed:@"product_noData_icon"];
        } else {
            self.noviceSign_imageV.hidden = NO;
            self.noviceSign_imageV.image = [UIImage imageNamed:@"product_newPeople_icon"];
        }
    } else {
        
        if (model.schedule == 100) {
            self.noviceSign_imageV.hidden = NO;
            self.noviceSign_imageV.image = [UIImage imageNamed:@"product_noData_icon"];
        } else {
            self.noviceSign_imageV.hidden = YES;
        }
    }
    
    // 额外增加的收益
    if (model.awardApr == 0) {
        self.awardApr_btn.hidden = YES;
    } else {
        self.awardApr_btn.hidden = NO;
    }
    [self.awardApr_btn setTitle:[NSString stringWithFormat:@"  + %.2f%%", model.awardApr] forState:(UIControlStateNormal)];
    
    
    // 投资时间
    self.timeLimit_label.text = [NSString stringWithFormat:@"%@天", model.timeLimit];
    // 最低起投金额
    self.purchaseAmount_label.text = [NSString stringWithFormat:@"%.f", [model.balance floatValue]];
    
    // 进度条
    self.progressView.progress = model.schedule / 100;
}

// 重写frame修改cell大小
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    // 在上面修改frame， 外界无法修改控件的frame
    [super setFrame:frame];
}

@end
