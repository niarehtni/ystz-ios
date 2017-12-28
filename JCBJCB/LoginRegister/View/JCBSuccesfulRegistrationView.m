//
//  JCBSuccesfulRegistrationView.m
//  JCBJCB
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBSuccesfulRegistrationView.h"
#import "JCBBonusBonusVC.h"

@interface JCBSuccesfulRegistrationView ()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UILabel *left_label;
@end

@implementation JCBSuccesfulRegistrationView

static NSUInteger timeOut = 3;

//jcb_succesfulRegistration_bonus
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"jcb_succesfulRegistration_bonus"];
    CGFloat imageViewX = SG_screenWidth * 0.22;
    CGFloat imageViewW = SG_screenWidth - 2 * imageViewX;
    CGFloat imageViewH = imageView.image.size.height * imageViewW / imageView.image.size.width;
    CGFloat imageViewY = SG_screenHeight * 0.18;
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self addSubview:imageView];
    
    // 2.立即领取
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.backgroundColor = SGColorWithRed;
    CGFloat startBtnW = SG_screenWidth * 0.5;
    CGFloat startBtnX = (SG_screenWidth - startBtnW)/2;
    CGFloat startBtnY = CGRectGetMaxY(imageView.frame) + 3 * SGMargin;
    CGFloat startBtnH;
    if (iphone5s) {
        startBtnH = SGLoginBtnWithIphone5sHeight;
    } else if (iphone6s) {
        startBtnH = SGLoginBtnWithIphone6sHeight;
    } else if (iphone6P) {
        startBtnH = SGLoginBtnWithIphone6PHeight;
    }
    
    startBtn.frame = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
    [startBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    //startBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [startBtn addTarget:self action:@selector(recevieImmediatelyBtn_action) forControlEvents:UIControlEventTouchUpInside];
    [SGSmallTool SG_smallWithThisView:startBtn cornerRadius:7];
    [self addSubview:startBtn];
    
    // 倒计时消失
    UIView *bgView = [[UIView alloc] init];
    CGFloat bgViewW = 160;
    CGFloat bgViewX = (SG_screenWidth - bgViewW)/2;
    CGFloat bgViewY = CGRectGetMaxY(startBtn.frame) + 2 * SGMargin + SGSmallMargin;
    CGFloat bgViewH = 30;
    bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    //bgView.backgroundColor = SGColorWithRandom;
    [self addSubview:bgView];
    
    UILabel *left_label = [[UILabel alloc] init];
    CGFloat left_labelX = 0;
    CGFloat left_labelY = 0;
    CGFloat left_labelW = 37;
    CGFloat left_labelH = bgViewH;
    left_label.frame = CGRectMake(left_labelX, left_labelY, left_labelW, left_labelH);
    left_label.text = @"5秒";
    left_label.textColor = SGColorWithWhite;
    left_label.textAlignment = NSTextAlignmentCenter;
    left_label.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:left_label];
    self.left_label = left_label;
    
    UILabel *right_label = [[UILabel alloc] init];
    CGFloat right_labelW = bgViewW - left_labelW;
    CGFloat right_labelX = CGRectGetMaxX(left_label.frame);
    CGFloat right_labelY = 0;
    CGFloat right_labelH = bgViewH;
    right_label.frame = CGRectMake(right_labelX, right_labelY, right_labelW, right_labelH);
    right_label.text = @"后自动跳转到首页";
    right_label.textColor = SGColorWithRGB(244, 153, 32);
    //right_label.backgroundColor = SGColorWithRandom;
    right_label.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:right_label];

    // 倒计时时间
    [self startTimer];

}

#pragma mark - - - 立即使用的点击事件
- (void)recevieImmediatelyBtn_action {
    [self invalidateTimer];
    [self removeFromSuperview];
    
    JCBBonusBonusVC *VC = [[JCBBonusBonusVC alloc] init];
    [self.bridgeNavigationC pushViewController:VC animated:YES];
}

#pragma mark - - - 倒计时
- (void)timer_action {
    if (timeOut <= 0) {
        [_timer invalidate];
        _timer = nil;
        
        [self removeFromSuperview];
    } else {
        self.left_label.text = [NSString stringWithFormat:@"%ld秒", (long)timeOut];
        timeOut = timeOut - 1;
        
        SGDebugLog(@"timeOut - - %ld", timeOut);
    }
}

#pragma mark - - - NSTimer
/** 开启线程 */
- (void)startTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer_action) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
/** 取消线程 */
- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

@end


