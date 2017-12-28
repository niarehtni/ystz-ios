//
//  NewFeatureView.m
//  JCBJCB
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "NewFeatureView.h"

@interface NewFeatureView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation NewFeatureView

static NSUInteger const NewVersionCharacteristicsImageCount = 5;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)newFeatureViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (void)setupSubviews {
    // 1.创建一个 scrollView：显示所有的新特性图片
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
    [self addSubview:self.scrollView];
    
    // 2.添加图片到 scrollView 中
    CGFloat scrollW = _scrollView.SG_width;
    CGFloat scrollH = _scrollView.SG_height;
    for (int i = 0; i < NewVersionCharacteristicsImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.SG_width = scrollW;
        imageView.SG_height = scrollH;
        imageView.SG_y = 0;
        imageView.SG_x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_image%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [self.scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == NewVersionCharacteristicsImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置 scrollView 的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    _scrollView.contentSize = CGSizeMake(NewVersionCharacteristicsImageCount * scrollW, 0);
    _scrollView.bounces = NO; // 去除弹簧效果
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    SGDebugLog(@"_scrollView - - - %@", _scrollView);
}

#pragma mark - - - scrollViewDelegate
/** 初始化最后一个 imageView */
- (void)setupLastImageView:(UIImageView *)imageView {
    // 1.开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 2.立即领取
    UIButton *startBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    startBtn.backgroundColor = SGCommonRedColor;
    CGFloat startBtnW = SG_screenWidth;
    CGFloat startBtnH = 0;
    if (iphone4s || iphone5s) {
        startBtnH = 44;
    } else if (iphone6s) {
        startBtnH = 48;
    } else if (iphone6P) {
        startBtnH = 52;
    }
    CGFloat startBtnX = 0;
    CGFloat startBtnY = SG_screenHeight - startBtnH;
    startBtn.frame = CGRectMake(startBtnX, startBtnY, startBtnW, startBtnH);
    [startBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    //[startBtn setImage:[UIImage imageNamed:@"newFeature_small_icon"] forState:(UIControlStateNormal)];
    //startBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - 6 * SGMargin, 0, 0);
    //startBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 16 * SGMargin, 0, 0);
    //startBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    //[SGSmallTool SG_smallWithThisView:startBtn cornerRadius:7];
    [imageView addSubview:startBtn];
}

- (void)startClick{
    [self removeFromSuperview];
}

@end


