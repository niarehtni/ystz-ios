//
//  JCBLoginRegisterVC.m
//  JCBJCB
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBLoginRegisterVC.h"
#import "JCBLoginVC.h"
#import "JCBRegisterVC.h"

@interface JCBLoginRegisterVC ()
/** 底部图片 */
@property (nonatomic, strong) UIImageView *bg_imageView;
/** 标题按钮底部的指示器 */
@property (nonatomic, strong) UIImageView *indicatorView;
/** 登录注册菜单View */
@property (nonatomic, strong) UIView *chooseView;
/** 当前选中的标题按钮 */
@property (nonatomic, strong) UIButton *selectedTitleButton;

@property (nonatomic, strong) UIScrollView *bg_scrollView;
@end

@implementation JCBLoginRegisterVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    [self setupSubviews];
}


- (void)setupSubviews {
    // 设置背景照片
    self.bg_imageView = [[UIImageView alloc] init];
    _bg_imageView.frame = CGRectMake(0, 0, SG_screenWidth, mineTopImageViewHeight);
    _bg_imageView.image = [UIImage imageNamed:@"mine_top_bg_image"];
    _bg_imageView.userInteractionEnabled = YES;
    [self.view addSubview:_bg_imageView];
    
    if ([JCBSingletonManager sharedSingletonManager].isReviseGesturePWVCToLoginRegister == YES || [JCBSingletonManager sharedSingletonManager].isUnlockGesturePWVCToLoginRegister == YES) {
        //[JCBSingletonManager sharedSingletonManager].isReviseGesturePWVCToLoginRegister = NO;
    } else {
        // 设置返回按钮
        UIImageView *back_icon = [[UIImageView alloc] init];
        back_icon.image = [UIImage imageNamed:@"login_register_backImage"];
        back_icon.frame = CGRectMake(3, 3 * SGMargin, back_icon.image.size.width, back_icon.image.size.height);
        [_bg_imageView addSubview:back_icon];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button addTarget:self action:@selector(TopBackBarButtomItemAction) forControlEvents:(UIControlEventTouchUpInside)];
        button.frame = CGRectMake(10, 37, 30, 30);
        [_bg_imageView addSubview:button];
    }

   
    self.bg_scrollView = [[UIScrollView alloc] init];
    _bg_scrollView.frame = CGRectMake(0, mineTopImageViewHeight, SG_screenWidth, SG_screenHeight - mineTopImageViewHeight);
    _bg_scrollView.contentSize = CGSizeMake(SG_screenWidth * 2, 0);
    _bg_scrollView.backgroundColor = [UIColor clearColor];
    // 没有弹簧效果
    _bg_scrollView.bounces = NO;
    _bg_scrollView.scrollEnabled = NO;
    // 隐藏水平滚动条
    _bg_scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bg_scrollView];
    
    // 创建登录注册菜单View
    [self setupLoginRegisterMuneView];
}

- (void)TopBackBarButtomItemAction {
    [SGNotificationCenter postNotificationName:kLoginVC object:nil];
    [SGNotificationCenter postNotificationName:kRegisterVC object:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
}

- (void)setupLoginRegisterMuneView {
    self.chooseView = [[UIView alloc] init];
    CGFloat chooseViewH = 44;
    CGFloat chooseViewY = mineTopImageViewHeight - 44;
    _chooseView.frame = CGRectMake(0, chooseViewY, SG_screenWidth, chooseViewH);
    _chooseView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [_bg_imageView addSubview:_chooseView];
    
    // 添加标题
    NSArray *login_register_arr = @[@"登录", @"注册"];
    CGFloat buttonW = _chooseView.SG_width / login_register_arr.count;
    CGFloat buttonH = _chooseView.SG_height;
    for (NSUInteger i = 0; i < login_register_arr.count; i++) {
        // 创建
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseView addSubview:button];
        
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
    self.indicatorView = [[UIImageView alloc] init];
    _indicatorView.image = [UIImage imageNamed:@"login_register_indicator"];
    CGFloat indicationViewW = _indicatorView.image.size.width;
    CGFloat indicationViewH = _indicatorView.image.size.height;
    CGFloat indicationViewY = _chooseView.SG_height - indicationViewH;
    CGFloat indicationViewx = (_chooseView.SG_width * 0.5 - indicationViewW) * 0.5;
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
    
    // 3.键盘回收
    [UIView animateWithDuration:0.25 animations:^{
        [self.view endEditing:YES];
    }];
    
}

/** 创建子控制器 */
- (void)setupChildViewController {
    // 登录
    JCBLoginVC *loginVC = [[JCBLoginVC alloc] init];
    [self addChildViewController:loginVC];
    
    // 注册
    JCBRegisterVC *registerVC = [[JCBRegisterVC alloc] init];
    [self addChildViewController:registerVC];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * SG_screenWidth;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.bg_scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, SG_screenWidth, SG_screenHeight - mineTopImageViewHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


