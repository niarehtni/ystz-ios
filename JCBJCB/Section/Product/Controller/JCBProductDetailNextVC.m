//
//  JCBProductDetailNextVC.m
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailNextVC.h"
#import "JCBProductDetailNextLeftVC.h"
#import "JCBProductDetailNextCenterVC.h"
#import "JCBProductDetailNextRightVC.h"

@interface JCBProductDetailNextVC () <SGSegmentedControlStaticDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;
@end

@implementation JCBProductDetailNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"项目详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItem_action) image:@"navigationButtonReturn" highImage:nil];
    
    // leftVC
    JCBProductDetailNextLeftVC *leftVC = [[JCBProductDetailNextLeftVC alloc] init];
    leftVC.idStr = self.idString;
    [self addChildViewController:leftVC];
    
    // centerVC
    JCBProductDetailNextCenterVC *centerVC = [[JCBProductDetailNextCenterVC alloc] init];
    centerVC.idStr = self.idString;
    [self addChildViewController:centerVC];
    
    // rightVC
    JCBProductDetailNextRightVC *rightVC = [[JCBProductDetailNextRightVC alloc] init];
    rightVC.idStr = self.idString;
    [self addChildViewController:rightVC];
    
    NSArray *childVC = @[leftVC, centerVC, rightVC];
    
    NSArray *title_arr = @[@"项目描述", @"材料公示", @"投资记录"];
    
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, navigationAndStatusBarHeight + cellDeautifulHeight, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    //_bottomSView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, navigationAndStatusBarHeight, self.view.frame.size.width, cellDeautifulHeight) delegate:self childVcTitle:title_arr];
    //_topSView.showsBottomScrollIndicator = NO;
    [self.view addSubview:_topSView];
}

- (void)leftBarButtonItem_action {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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


@end
