//
//  JCBMineVC.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBMineVC.h"
#import "JCBMineTopTVCell.h"
#import "JCBMineModel.h"
#import "JCBMineOneTVCell.h"
#import "JCBMineTwoTVCell.h"
#import "JCBMineThreeTVCell.h"
#import "JCBLoginRegisterVC.h"
#import "JCBAccountSettingVC.h"
#import "JCBRechargeCashVC.h"
#import "JCBBonusBonusVC.h"
#import "JCBFundRecordVC.h"
#import "JCBInviteFriendsVC.h"
#import "JCBInvestmentRecordVC.h"
#import "JCBPaymentRecordsVC.h"
#import "JCBTabBarController.h"
#import "JCBRongBaoPayVC.h"
#import "JCBTotalAssetsVC.h"

@interface JCBMineVC () <UITableViewDelegate, UITableViewDataSource, SGAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataSource_dic;
/** 底部图片 */
@property (nonatomic, strong) UIImageView *bg_imageView;

@property (nonatomic, strong) NSDictionary *isBindCard_dic;
@property (nonatomic, strong) NSDictionary *isHaveNewRedNum_dic;
@end

@implementation JCBMineVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:signIn] isEqualToString:@"down"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:comeFromTabbarIndex] isEqualToString:@"0"]) {
            self.tabBarController.selectedIndex = 0;
            return;
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:comeFromTabbarIndex] isEqualToString:@"1"]) {
            self.tabBarController.selectedIndex = 1;
            return;
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:comeFromTabbarIndex] isEqualToString:@"3"]) {
            self.tabBarController.selectedIndex = 3;
            return;
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadNewDataSourse];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SGCommonBgColor;

    // 配置tableView
    [self setupTableView];
    [self setupRefresh];
    
}

#pragma mark - - - refresh
- (void)setupRefresh{
    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    //[self.tableView.mj_header beginRefreshing];
}

// 轮播图上面的数据获取
- (void)loadNewDataSourse {

    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"userCenter - json - - - %@", json);
        [JCBSingletonManager sharedSingletonManager].user_money = json[@"ableMoney"]; // 用户账户余额，单例传值，用户充值提现界面的充值界面
        
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        [self.tableView.mj_header endRefreshing];

        if (![json[@"rcd"] isEqualToString:@"R0001"]) { // 没有登录成功
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userAccessToken];
            
            JCBLoginRegisterVC *loginRVC = [[JCBLoginRegisterVC alloc] init];
            UINavigationController * newNavigationC = [[UINavigationController alloc] initWithRootViewController:loginRVC];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"down" forKey:signIn];
            // 立即同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 模态导航控制器
            [self presentViewController:newNavigationC animated:YES completion:^{
                
            }];
            
        } else if ([json[@"rcd"] isEqualToString:@"R0001"]) { // 登录成功
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:signIn];
            // 立即同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            JCBMineModel *model = [JCBMineModel JCBMineWithDictionary:json];
            self.dataSource_dic = (NSDictionary *)model;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        [self.tableView.mj_header endRefreshing];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
        });
        
        SGDebugLog(@"error - - - %@", error);
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userAccessToken];
        
        JCBLoginRegisterVC *loginRVC = [[JCBLoginRegisterVC alloc] init];
        UINavigationController * newNavigationC = [[UINavigationController alloc] initWithRootViewController:loginRVC];
        [[NSUserDefaults standardUserDefaults] setObject:@"down" forKey:signIn];
        // 立即同步
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 模态导航控制器
        [self presentViewController:newNavigationC animated:YES completion:^{
            
        }];
        
    }];
    
#pragma mark - - - 判断是否绑定银行卡
    // 判断是否绑定银行卡
    [self toDetermineWhetherToBindTheBankCard];
#pragma mark - - - 判断是否有新的红包数
    [self toDetermineWhetherHaveNewRedNum];

}

/** 判断是否绑定银行卡 */
- (void)toDetermineWhetherToBindTheBankCard {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/rechargeTo", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"rechargeTo - dictionary - - - %@", dictionary);
        self.isBindCard_dic = dictionary;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
}
/** 判断是否有新的红包数 */
- (void)toDetermineWhetherHaveNewRedNum {
    NSString *newRedUrlStr = [NSString stringWithFormat:@"%@/rest/hbNotLookCount", SGCommonURL];
    
    newRedUrlStr = [newRedUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:newRedUrlStr];
    
    [SGHttpTool postAll:newRedUrlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"newRedUrlStr - dictionary - - - %@", dictionary);
        self.isHaveNewRedNum_dic = dictionary;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
        
    }];
}

- (void)setupTableView {
    
    self.tableView.backgroundColor = SGCommonBgColor;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBMineTopTVCell class]) bundle:nil] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBMineOneTVCell class]) bundle:nil] forCellReuseIdentifier:@"oneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBMineTwoTVCell class]) bundle:nil] forCellReuseIdentifier:@"twoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBMineThreeTVCell class]) bundle:nil] forCellReuseIdentifier:@"threeCell"];
}

#pragma mark - - - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JCBMineTopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.settingButton addTarget:self action:@selector(settingButton_action) forControlEvents:(UIControlEventTouchUpInside)];
        JCBMineModel *model = (JCBMineModel *)self.dataSource_dic;
        cell.model = model;
        return cell;
    } else if (indexPath.section == 1) {
        JCBMineOneTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:cell.leftView target:self action:@selector(leftViewAction)];
        JCBMineModel *model = (JCBMineModel *)self.dataSource_dic;
        cell.model = model;

        return cell;
    } else if (indexPath.section == 2) { // 邀请好友 cell
        JCBMineTwoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        JCBMineThreeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.recharge_cash_btn addTarget:self action:@selector(recharge_cash_btn_action) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.bonus_bonus_btn addTarget:self action:@selector(bonus_bonus_btn_action) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.fund_record_btn addTarget:self action:@selector(fund_record_btn_action) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.investment_record_btn addTarget:self action:@selector(investment_record_btn_action) forControlEvents:UIControlEventTouchUpInside];
        // 判断是否有新的红包数以及是否显示红包提示圆点
        if ([self.isHaveNewRedNum_dic[@"rmg"] isEqualToString:@"0"]) {
            cell.smallDot.hidden = YES;
        } else {
            cell.smallDot.hidden = NO;
        }
        return cell;
    }

}

#pragma mark - - - 总资产按钮的点击事件
- (void)leftViewAction {
//    JCBTotalAssetsVC *TAVC = [[JCBTotalAssetsVC alloc] init];
//    [self.navigationController pushViewController:TAVC animated:YES];
}

#pragma mark - - - 充值提现点击事件
- (void)recharge_cash_btn_action {
    JCBRechargeCashVC *rechangeCashVC = [[JCBRechargeCashVC alloc] init];
    [self.navigationController pushViewController:rechangeCashVC animated:YES];
    //JCBRongBaoPayVC *rongBaoVC = [[JCBRongBaoPayVC alloc] init];
    //[self.navigationController pushViewController:rongBaoVC animated:YES];

}

#pragma mark - - - 红包奖励
- (void)bonus_bonus_btn_action {
    JCBBonusBonusVC *bonusBonusVC = [[JCBBonusBonusVC alloc] init];
    [self.navigationController pushViewController:bonusBonusVC animated:YES];
}

#pragma mark - - - 投资记录
- (void)investment_record_btn_action {
    JCBInvestmentRecordVC *IRVC = [[JCBInvestmentRecordVC alloc] init];
    [self.navigationController pushViewController:IRVC animated:YES];
}

#pragma mark - - - 资金记录
- (void)fund_record_btn_action {
    JCBFundRecordVC *fundRecordVC = [[JCBFundRecordVC alloc] init];
    [self.navigationController pushViewController:fundRecordVC animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        SGDebugLog(@" - - - - ");
        JCBInviteFriendsVC *IFVC = [[JCBInviteFriendsVC alloc] init];
        [self.navigationController pushViewController:IFVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //
        return mineTopImageViewHeight;
    } else if (indexPath.section == 1){  // 今日收益、投资记录、汇款记录 cell
        if (iphone5s) {
            return 62;
        } else if (iphone6s) {
            return 72;
        } else if (iphone6P){
            return 82;
        } else {
            return 52;
        }
    } else if (indexPath.section == 2){ // 邀请好友 cell
        if (iphone5s) {
            return 50;
        } else if (iphone6s) {
            return 56;
        } else if (iphone6P){
            return 66;
        } else {
            return 45;
        }
    } else if (indexPath.section == 3){ // 底部 cell
        return SG_screenHeight * 0.34;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.01;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - - - 设置按钮的点击事件
- (void)settingButton_action {
    
    JCBAccountSettingVC *accounSVC = [[JCBAccountSettingVC alloc] init];
    
    [self.navigationController pushViewController:accounSVC animated:YES];
}


- (void)dealloc {
    SGDebugLog(@"JCBMineVC - - dealloc");
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


