//
//  JCBPushGuideView.m
//  JCBJCB
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBPushGuideView.h"
#import "JCBActivityCenterVC.h"
#import "JCBContentDetailsVC.h"
#import "JCBContentDetailsVC.h"

@interface JCBPushGuideView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancel_button;

@end

@implementation JCBPushGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

    }
    return self;
}
 

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:_imageView target:self action:@selector(didSelectedImage)];
    }
    return _imageView;
}
    
- (UIButton *)cancel_button {
    if (!_cancel_button) {
        _cancel_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //_cancel_button.backgroundColor = SGColorWithRandom;
        [_cancel_button setBackgroundImage:[UIImage imageNamed:@"jcb_pushGuide_cancel_btn_icon"] forState:(UIControlStateNormal)];
        [_cancel_button addTarget:self action:@selector(cancel_buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancel_button;
}

+ (instancetype)JCBPushGuideViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (void)setPushGuide_dic:(NSDictionary *)pushGuide_dic {
    _pushGuide_dic = pushGuide_dic;
    NSString *imageUrl = [NSString stringWithFormat:@"%@/mobile%@", SGCommonImageURL, self.pushGuide_dic[@"imageUrl"]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        //self.imageView.image = [UIImage imageNamed:@"test1"];
        CGFloat imageViewW = SG_screenWidth * 3 / 4;
        CGFloat imageViewX = 0.5 * (SG_screenWidth - imageViewW);
        //CGFloat imageViewH = self.imageView.image.size.height * imageViewW / self.imageView.image.size.width;
        CGFloat imageViewH = image.size.width>0? image.size.height * imageViewW / image.size.width:0.0f;
        CGFloat imageViewY = (SG_screenHeight - imageViewH) * 0.5;
#pragma mark - - - 正式环境要打开
        _imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        [self addSubview:_imageView];

        /*
        CGFloat cancel_buttonW = 40;
        CGFloat cancel_buttonH = cancel_buttonW;
        CGFloat cancel_buttonX = (SG_screenWidth - cancel_buttonW) * 0.5;
        CGFloat cancel_buttonY = CGRectGetMaxY(self.imageView.frame);
        self.cancel_button.frame = CGRectMake(cancel_buttonX, cancel_buttonY, cancel_buttonW, cancel_buttonH);
        */
        
        self.cancel_button.SG_x = CGRectGetMaxX(self.imageView.frame);
        _cancel_button.SG_y = self.imageView.SG_y - 2 * SGMargin - 0.5 * SGSmallMargin;
        [_cancel_button sizeToFit];

        [self addSubview:_cancel_button];
    }];
}

- (void)didSelectedImage {
    SGDebugLog(@" - - - - - ");
    if ([self.pushGuide_dic[@"typeTarget"] rangeOfString:@"activity"].location != NSNotFound) { // 活动中心
        NSArray *array = [self.pushGuide_dic[@"typeTarget"] componentsSeparatedByString:@"id="];
        NSString *Id = array[1];
        JCBActivityCenterVC *activityCVC = [[JCBActivityCenterVC alloc] init];
        activityCVC.content_id = Id;
        [self.bridgeNavigationC pushViewController:activityCVC animated:YES];
        
    } else if ([self.pushGuide_dic[@"typeTarget"] rangeOfString:@"article"].location != NSNotFound){ // 内容详情
        
        NSArray *array = [self.pushGuide_dic[@"typeTarget"] componentsSeparatedByString:@"content/"];
        NSString *string = array[1];
        NSArray *A = [string componentsSeparatedByString:@".htm"];
        string = A[0];
        
        JCBContentDetailsVC *contentDVC = [[JCBContentDetailsVC alloc] init];
        contentDVC.content_id = string;
        [self.bridgeNavigationC pushViewController:contentDVC animated:YES];
        SGDebugLog(@"%@",string);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:didSelectImageOfPushGuideView];
    // 立即同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeFromSuperview];
}

- (void)cancel_buttonAction {
    [JCBSingletonManager sharedSingletonManager].isSelectedCancelBtn = YES;
    [self removeFromSuperview];
}



@end


