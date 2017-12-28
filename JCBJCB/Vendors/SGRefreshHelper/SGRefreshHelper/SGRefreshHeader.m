//
//  SGRefreshHeader.m
//  SGRefreshHelper
//
//  Created by Sorgle on 16/7/10.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGRefreshHeader.h"

@interface SGRefreshHeader ()
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation SGRefreshHeader

/**
 *  初始化
 */
- (void)prepare {
    [super prepare];
    
//    self.automaticallyChangeAlpha = YES;
//    self.lastUpdatedTimeLabel.textColor = [UIColor orangeColor];
//    self.stateLabel.textColor = [UIColor orangeColor];
//    [self setTitle:@"赶紧下拉吧" forState:MJRefreshStateIdle];
//    [self setTitle:@"赶紧松开吧" forState:MJRefreshStatePulling];
//    [self setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];
//    //    self.lastUpdatedTimeLabel.hidden = YES;
//    //    self.stateLabel.hidden = YES;
//    [self addSubview:[[UISwitch alloc] init]];
//    
//    UIImageView *logo = [[UIImageView alloc] init];
//    logo.image = [UIImage imageNamed:@"bd_logo1"];
//    [self addSubview:logo];
//    self.logo = logo;
}

/**
 *  摆放子控件
 */
- (void)placeSubviews {
    [super placeSubviews];
    
//    self.logo.SG_width = self.SG_width;
//    self.logo.SG_height = 50;
//    self.logo.SG_x = 0;
//    self.logo.SG_y = - 50;
}


@end
