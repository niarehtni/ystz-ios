//
//  JCBHomeVC.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBHomeVC.h"
#import "SGOneTableViewCell.h"
#import "SGTwoTableViewCell.h"
#import "SGThreeTableViewCell.h"
#import "SGFourTableViewCell.h"
#import "JCBFourCellModel.h"
#import "JCBProductDetailVC.h" // Product
#import "SGFiveTableViewCell.h"
#import "JCBLoopModel.h"
#import "JCBActivityCenterVC.h"
#import "JCBContentDetailsVC.h"
#import "AppDelegate.h"
#import "JCBTabBarController.h"
#import "JCBProductVC.h"
#import "JCBProductDetailVC.h"
#import "JCBInviteFriendsVC.h"
#import "JCBPushGuideView.h"
#import "JCBSuccesfulRegistrationView.h"
#import "JCBLatestActivityCenterVC.h"
#import "JCBLatestActivityVC.h"
#import "JCBCustomerServiceVC.h"

@interface JCBHomeVC () <UITableViewDelegate, UITableViewDataSource, SGOneTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *loopImage_arr;
@property (nonatomic, strong) NSMutableArray *loopImageDetail_arr;
@property (nonatomic, strong) NSMutableDictionary *dataSource_mDic;

@property (nonatomic, strong) NSDictionary *outside_dic;

@property (nonatomic, strong) NSDictionary *dataSource_dic_twoCell;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) NSArray *dataSource_arr_new_Activity;
@property (nonatomic, strong) NSDictionary *dataSource_dic_login;
@end

@implementation JCBHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [SGUserDefaults setObject:nil forKey:signIn];
    [SGUserDefaults setObject:@"0" forKey:comeFromTabbarIndex];
    // 立即同步
    [SGUserDefaults synchronize];
    
    // 加载最新活动页上面的数据
    [self loadPushGuideViewData];
    
#pragma mark - - - 注册成功才会出现的红包界面 view
    if ([[SGUserDefaults objectForKey:isSuccesfulRegistration] isEqualToString:@"YES"]) {
        // 保存第一次注册成功的 key 值
        [SGUserDefaults setObject:nil forKey:isSuccesfulRegistration];
        // 立即同步
        [SGUserDefaults synchronize];
        
        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
        JCBSuccesfulRegistrationView *SRView = [[JCBSuccesfulRegistrationView alloc] init];
        SRView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        SRView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
        SRView.bridgeNavigationC = self.navigationController;
        [appD.window addSubview:SRView];
    }
    
}

#pragma mark - - - 加载最新活动页上面的数据
- (void)loadPushGuideViewData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/scrollpic?way=4", SGCommonURL];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"scrollpic - dictionary - - %@", dictionary);
        
        if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) { // 没有活动图不创建 JCBPushGuideView
            if ([[NSString stringWithFormat:@"%@", dictionary[@"typeTarget"]] isEqualToString:@"(null)"] || [[NSString stringWithFormat:@"%@", dictionary[@"typeTarget"]] isEqualToString:@"<null>"]) {
                
            } else {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:didSelectImageOfPushGuideView] isEqualToString:@"YES"]) {
                    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"imageUrl"] isEqualToString:dictionary[@"imageUrl"]]) {
                        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"imageUrl"] forKey:@"imageUrl"];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:didSelectImageOfPushGuideView];
                        // 立即同步
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        JCBPushGuideView *PGView = [JCBPushGuideView JCBPushGuideViewWithFrame:(CGRectMake(0, 0, SG_screenWidth, SG_screenHeight))];
                        PGView.bridgeNavigationC = self.navigationController;
                        PGView.pushGuide_dic = dictionary;
                        [appD.window addSubview:PGView];
                    }
                } else {
                    
                    if ([JCBSingletonManager sharedSingletonManager].isSelectedCancelBtn == NO) {
                        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"imageUrl"] forKey:@"imageUrl"];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:didSelectImageOfPushGuideView];
                        // 立即同步
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        JCBPushGuideView *PGView = [JCBPushGuideView JCBPushGuideViewWithFrame:(CGRectMake(0, 0, SG_screenWidth, SG_screenHeight))];
                        PGView.bridgeNavigationC = self.navigationController;
                        PGView.pushGuide_dic = dictionary;
                        [appD.window addSubview:PGView];
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - %@", error);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SGCommonBgColor;
    
    self.loopImage_arr = [NSMutableArray array];
    self.loopImageDetail_arr = [NSMutableArray array];
    
    [self foundTableView];
    [self setupRefresh];
    
    // 添加客服悬浮按钮
    [self setupCustomerServiceSuspensionBtn];
}


// 轮播图上面的数据获取
- (void)loadNewDataSourse {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/indexH", SGCommonURL];
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"indexBorrow"] = @"indexBorrow";
    params[@"indexImageItemList"] = @"indexImageItemList";
    
    [SGHttpTool postAll:urlStr params:params success:^(id json) {
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        self.outside_dic = json;
        
        SGDebugLog(@"%@", json);
        NSArray *arr = json[@"indexImageItemList"];
        //self.dataSource_mDic = json[@"indexBorrow"];
        JCBFourCellModel *model = [[JCBFourCellModel alloc] initWithDictionary:json[@"indexBorrow"]];
        self.dataSource_mDic = (NSMutableDictionary *)model;
        // SGDebugLog(@"dataSource_mDic - - -%@", self.dataSource_mDic);
        
        [self.loopImage_arr removeAllObjects];

        for (NSDictionary *dic in arr) {
            JCBLoopModel *model = [[JCBLoopModel alloc] initWithDictionary:dic];
            NSString *new_image_arr = [NSString stringWithFormat:@"%@/mobile%@", SGCommonImageURL, model.imageUrl];
            [self.loopImage_arr addObject:new_image_arr];
            [self.loopImageDetail_arr addObject:model.typeTarget];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD SG_hideHUDForView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请检测您的网络是否正常连接" delayTime:1.0];
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
        });
        SGDebugLog(@"%@", error);
    }];
    
#pragma mark - - - 理财人数以及金额数
    NSString *twoUrlStr = [NSString stringWithFormat:@"%@/rest/indexH", SGCommonURL];
    //twoUrlStr = [twoUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:twoUrlStr];
    [SGHttpTool postAll:twoUrlStr params:nil success:^(id json) {
        SGDebugLog(@"twoUrlStr - json - - %@", json);
        self.dataSource_dic_twoCell = json;

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SGDebugLog(@"twoUrlStr - error - - %@", error);
        
    }];
    
#pragma mark - - - 最新活动数据
    self.firstPageNumber = 1;
    NSString *activityUrlStr = [NSString stringWithFormat:@"%@/rest/activity?pageNumber=%ld&pageSize=150", SGCommonURL, self.firstPageNumber];
    //activityUrlStr = [activityUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:activityUrlStr];

    [SGHttpTool getAll:activityUrlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"activity - json - - %@", json);
        self.dataSource_arr_new_Activity = json[@"activityList"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"error - - -  %@", error);
    }];

#pragma mark - - - 判断用户有没有登录
    [self isLogin];
}

- (void)isLogin {
    NSString *loginUrlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    loginUrlStr = [loginUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:loginUrlStr];
    [SGHttpTool getAll:loginUrlStr params:nil success:^(id json) {
        SGDebugLog(@"userCenter - json - - -  %@", json);
        self.dataSource_dic_login = json;
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - -  %@", error);
    }];
}

#pragma mark - - - refresh
- (void)setupRefresh{
    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)foundTableView {
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.backgroundColor = SGCommonBgColor;
    
    [self.tableView registerClass:[SGOneTableViewCell class] forCellReuseIdentifier:@"oneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SGTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"twoCell"];
    //[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SGThreeTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"threeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SGFourTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"fourCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SGFiveTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"fiveCell"];
}

#pragma mark - - - 轮播图点击事件
- (void)oneTableViewCell:(SGOneTableViewCell *)oneTableViewCell didSelectItemAtIndex:(NSInteger)index {
    if ([self.loopImageDetail_arr[index] rangeOfString:@"activity"].location != NSNotFound) { // 活动中心
        NSArray *array = [self.loopImageDetail_arr[index] componentsSeparatedByString:@"id="];
        NSString *Id = array[1];
        JCBActivityCenterVC *activityCVC = [[JCBActivityCenterVC alloc] init];
        activityCVC.content_id = Id;
        [self.navigationController pushViewController:activityCVC animated:YES];
    } else if([self.loopImageDetail_arr[index] rangeOfString:@"article"].location != NSNotFound){ // 内容详情
        NSArray *array = [self.loopImageDetail_arr[index] componentsSeparatedByString:@"content/"];
        NSString *string = array[1];
        NSArray *A = [string componentsSeparatedByString:@".htm"];
        string = A[0];
        
        JCBContentDetailsVC *contentDVC = [[JCBContentDetailsVC alloc] init];
        contentDVC.content_id = string;
        [self.navigationController pushViewController:contentDVC animated:YES];
        SGDebugLog(@"%@",string);
    }
}

#pragma mark - - - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        SGOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        cell.delegate = self;
        cell.URLWithImage = self.loopImage_arr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        SGTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger userNum = [self.dataSource_dic_twoCell[@"totalUserNum"] integerValue];
        NSInteger totalmoney = [self.dataSource_dic_twoCell[@"totalTenderMoney"] integerValue];
        cell.leftLabel.text = [NSString stringWithFormat:@"  理财会员 %zd人", userNum];
        [SGSmallTool SG_smallWithThisLabel:cell.leftLabel frontText:@"  理财会员 " behindText:[NSString stringWithFormat:@"%zd", userNum] behindTextColor:SGColorWithRed behindTextFont:14 centerLineBool:NO];
        cell.rightLabel.text = [NSString stringWithFormat:@"  投资总额 %zd元", totalmoney];
        [SGSmallTool SG_smallWithThisLabel:cell.rightLabel frontText:@"  投资总额 " behindText:[NSString stringWithFormat:@"%zd", totalmoney] behindTextColor:SGColorWithRed behindTextFont:14 centerLineBool:NO];

        return cell;
    } else if (indexPath.section == 2)  {
        SGThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeCell"];
        if (!cell) {
            cell = [[SGThreeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"threeCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title_label.text = self.dataSource_arr_new_Activity[0][@"title"];
        NSString *startTime = self.dataSource_arr_new_Activity[0][@"startTime"];
        NSString *endTime = self.dataSource_arr_new_Activity[0][@"endTime"];
        NSString *frontTime = [NSString stringWithFormat:@"%@", startTime];
        frontTime = [frontTime SG_transformationTimeFormatWithYMDTime:[NSString stringWithFormat:@"%@", startTime]];
        NSString *behindTime = [NSString stringWithFormat:@"%@", endTime];
        behindTime = [behindTime SG_transformationTimeFormatWithYMDTime:[NSString stringWithFormat:@"%@", endTime]];
        NSString *sumTime = [NSString stringWithFormat:@"活动时间：%@－%@", frontTime, behindTime];
        cell.activityTime_label.text = sumTime;
        // 活动中心查看的点击事件
        [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:cell.left_imageView target:self action:@selector(threeCell_more_Btn_Action)];
        return cell;
    } else if (indexPath.section == 3) {
        SGFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.pushProductVCBtn addTarget:self action:@selector(pushProductVCBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
        JCBFourCellModel *model = (JCBFourCellModel *)self.dataSource_mDic;
        cell.model = model;
        return cell;
    } else {
        SGFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fiveCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.redPacker_money.text = @"260元";
        [cell.quickInvite_btn addTarget:self action:@selector(quickInvite_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) { // 最新活动详情
        JCBLatestActivityVC *LAVC = [[JCBLatestActivityVC alloc] init];
        LAVC.content_id = self.dataSource_arr_new_Activity[0][@"id"];
        [self.navigationController pushViewController:LAVC animated:YES];
    } else if (indexPath.section == 3) {
        JCBProductDetailVC *productDVC = [[JCBProductDetailVC alloc] init];
        JCBFourCellModel *model = (JCBFourCellModel *)self.dataSource_mDic;
        productDVC.idStr = model.ID;
        productDVC.scheduleIs100 = model.schedule;
        [self.navigationController pushViewController:productDVC animated:YES];
    }
}

#pragma mark - - - 活动中心的点击事件
- (void)threeCell_more_Btn_Action {
    JCBLatestActivityCenterVC *LACVC = [[JCBLatestActivityCenterVC alloc] init];
    [self.navigationController pushViewController:LACVC animated:YES];
}

#pragma mark - - - 邀请好友按钮的点击事件
- (void)quickInvite_btn_action:(UIButton *)button {
    // [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请登录后再邀请好友" delayTime:1.0];
    //[MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:nil toView:self.view];

    button.userInteractionEnabled = NO;
    
    NSString *loginUrlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    loginUrlStr = [loginUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:loginUrlStr];
    [SGHttpTool getAll:loginUrlStr params:nil success:^(id json) {
        SGDebugLog(@"userCenter - json - - -  %@", json);
        //[MBProgressHUD SG_hideHUDForView:self.view];
        button.userInteractionEnabled = YES;

        if ([json[@"rcd"] isEqualToString:@"R0001"]) {
            JCBInviteFriendsVC *inviteFriedsVC = [[JCBInviteFriendsVC alloc] init];
            [self.navigationController pushViewController:inviteFriedsVC animated:YES];
        } else {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请先登录，再进行分享" delayTime:1.5];
        }

    } failure:^(NSError *error) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请检测您的网络是否正常连接" delayTime:1.5];
        SGDebugLog(@"error - - -  %@", error);
        button.userInteractionEnabled = YES;
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return loopScrollViewHeight;
    } else if (indexPath.section == 1) {
        return cellDeautifulHeight;
    } else if (indexPath.section == 2) {
        return cellDeautifulHeight * 1.4;
    } else if (indexPath.section == 3) {
        return loopScrollViewHeight;
    } else {
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1){
        return SGMargin * 0.7;
    } else {
        return SGMargin * 0.7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - - - 添加客服悬浮按钮
- (void)setupCustomerServiceSuspensionBtn {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_custom_service_icon"] forState:(UIControlStateNormal)];
    [btn sizeToFit];
    btn.SG_x = SG_screenWidth - 40;
    btn.SG_y = (loopScrollViewHeight + 2.1 * SGMargin + cellDeautifulHeight + 1.4 * cellDeautifulHeight + loopScrollViewHeight * 0.49);
    [btn addTarget:self action:@selector(suspensionBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer_action:)];
    [btn addGestureRecognizer:panGR];
}

- (void)panGestureRecognizer_action:(UIPanGestureRecognizer *)recognizer {
    // 1、获取平移增量
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    // 2、限制屏幕范围
    // 最小 y 值限制
    newCenter.y = MAX(recognizer.view.frame.size.height / 2 + 2 * SGMargin, newCenter.y);
    // 最大 x 值限制
    newCenter.y = MIN(self.view.frame.size.height - recognizer.view.frame.size.height / 2 - cellDeautifulHeight - 0.5 * SGSmallMargin, newCenter.y);
    // 最小 x 值限制
    newCenter.x = MAX(recognizer.view.frame.size.width / 2, newCenter.x);
    // 最大 x 值限制
    newCenter.x = MIN(self.view.frame.size.width - recognizer.view.frame.size.width / 2, newCenter.x);
    recognizer.view.center = newCenter;
    
    // 3、将之前的增量清零
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)suspensionBtn_action {
    JCBCustomerServiceVC *CSVC = [[JCBCustomerServiceVC alloc] init];
    [self.navigationController pushViewController:CSVC animated:YES];
}

- (void)dealloc {
    SGDebugLog(@"JCBHomeVC - - dealloc");
}


@end
