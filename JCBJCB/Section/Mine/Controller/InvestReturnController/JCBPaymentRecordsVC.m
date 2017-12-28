//
//  JCBPaymentRecordsVC.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBPaymentRecordsVC.h"
#import "JCBPRStayBackVC.h"
#import "JCBPRHaveBeenBackVC.h"

@interface JCBPaymentRecordsVC () <SGSegmentedControlStaticDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;
@end

@implementation JCBPaymentRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"回款记录";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 待回款
    JCBPRStayBackVC *PRSBVC = [[JCBPRStayBackVC alloc] init];
    [self addChildViewController:PRSBVC];
    
    // 已回款
    JCBPRHaveBeenBackVC *PRHBBVC = [[JCBPRHaveBeenBackVC alloc] init];
    [self addChildViewController:PRHBBVC];
    
    NSArray *childVC = @[PRSBVC, PRHBBVC];
    
    NSArray *title_arr = @[@"待回款", @"已回款"];
    
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - navigationAndStatusBarHeight)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    _bottomSView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, SG_screenWidth, 44) delegate:self childVcTitle:title_arr];
    self.topSView.backgroundColor = SGColorWithWhite;
    //_topSView.showsBottomScrollIndicator = NO;
    [self.view addSubview:_topSView];

}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    SGDebugLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
