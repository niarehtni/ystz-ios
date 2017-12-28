//
//  JCBBonusBonusVC.m
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBBonusBonusVC.h"
#import "JCBRedVC.h"
#import "JCBRewardVC.h"
#import "JCBMineVC.h"

@interface JCBBonusBonusVC ()
/** 标题按钮底部的指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 登录注册菜单View */
@property (nonatomic, strong) UIView *chooseView;
/** 当前选中的标题按钮 */
@property (nonatomic, strong) UIButton *selectedTitleButton;

@property (nonatomic, strong) UIScrollView *bg_scrollView;

@end

@implementation JCBBonusBonusVC

static CGFloat const topViewHeight = 44.0;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包奖励";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    [self setupScrollView];
    [self setupSubviews];
}

- (void)setupSubviews {
    self.chooseView = [[UIView alloc] init];
    CGFloat chooseViewH = topViewHeight;
    CGFloat chooseViewY = 1;
    _chooseView.frame = CGRectMake(0, chooseViewY, SG_screenWidth, chooseViewH);
    _chooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_chooseView];
    
    // 添加标题
    NSArray *login_register_arr = @[@"红包", @"奖励"];
    CGFloat buttonW = _chooseView.SG_width / login_register_arr.count;
    CGFloat buttonH = _chooseView.SG_height;
    for (NSUInteger i = 0; i < login_register_arr.count; i++) {
        // 创建
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        // 设置数据
        [button setTitle:login_register_arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        // 设置frame
        button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        
        // 默认选中第0个button
        if (i == 0) {
            [self titleClick:button];
        }
    }
    
    // 底部的指示器
    self.indicatorView = [[UIView alloc] init];
    CGFloat indicationViewW = 70;
    CGFloat indicationViewH = 2;
    CGFloat indicationViewY = _chooseView.SG_height - 2 * indicationViewH;
    CGFloat indicationViewx = (SG_screenWidth * 0.5 - indicationViewW) * 0.5;
    _indicatorView.backgroundColor = SGColorWithRed;
    [_chooseView addSubview:_indicatorView];
    _indicatorView.frame = CGRectMake(indicationViewx, indicationViewY, indicationViewW, indicationViewH);
    
    [self showVc:0];
}

- (void)titleClick:(UIButton *)button {
    self.selectedTitleButton.selected = NO;
    button.selected = YES;
    self.selectedTitleButton = button;
    
    // 指示器
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.SG_centerX = button.SG_centerX;
    }];
    
    // 1 计算滚动的位置
    NSUInteger index = button.tag;
    CGFloat offsetX = index * SG_screenWidth;
    self.bg_scrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

- (void)setupScrollView {
    self.bg_scrollView = [[UIScrollView alloc] init];
    _bg_scrollView.frame = CGRectMake(0, topViewHeight + 2, SG_screenWidth, SG_screenHeight - (topViewHeight + navigationAndStatusBarHeight + 2));
    _bg_scrollView.contentSize = CGSizeMake(SG_screenWidth * 2, 0);
    _bg_scrollView.backgroundColor = [UIColor clearColor];
    // 没有弹簧效果
    _bg_scrollView.bounces = NO;
    _bg_scrollView.scrollEnabled = NO;
    _bg_scrollView.backgroundColor = SGColorWithRed;
    // 隐藏水平滚动条
    _bg_scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bg_scrollView];
}
/** 创建子控制器 */
- (void)setupChildViewController {
    // JCBRedVC
    JCBRedVC *redVC = [[JCBRedVC alloc] init];
    [self addChildViewController:redVC];
    
    // JCBRewardVC
    JCBRewardVC *rewardVC = [[JCBRewardVC alloc] init];
    [self addChildViewController:rewardVC];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * SG_screenWidth;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.bg_scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, SG_screenWidth, _bg_scrollView.SG_height);
}

@end
