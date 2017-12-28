//
//  JCBMoreVC.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBMoreVC.h"
#import "JCBNewsNoticeVC.h"
#import "JCBAboutUsVC.h"
#import "JCBHelpCenterVC.h"
#import "JCBCustomerServiceVC.h"
#import "JCBFeedbackVC.h"

@interface JCBMoreVC ()<UITableViewDelegate, UITableViewDataSource, SGActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isLogin;
// 退出登录按钮
@property (nonatomic, strong) UIButton *logoff_btn;
@end

@implementation JCBMoreVC

/** 最底部的footView高度 */
CGFloat const logoff_footView = 90;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:signIn];
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:comeFromTabbarIndex];
    // 立即同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self userIsLogin];
}

#pragma mark - - - 判断用户是否登录
- (void)userIsLogin {

    //[MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        //[MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        SGDebugLog(@"userCenter - json - - - %@", json);
        if ([json[@"rcd"] isEqualToString:@"R0001"]) { // 已登录
            self.isLogin = YES;
        } else {
            self.isLogin = NO;
        }
        // 刷新，解决用户在其他手机登录，出现退出登录按钮
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //[MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请检测您的网络是否正常连接" delayTime:1.0];
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
            
            [self.tableView reloadData];
        //});
        SGDebugLog(@"error - - - %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SGCommonBgColor;
    self.title = @"更多";

    // 配置tableView
    [self setupTableView];
    
    // 创建版本号提示文字
    [self setupVersionNumber];
}

- (void)setupTableView {
    // 注册
    self.tableView.backgroundColor = SGCommonBgColor;
    if (iphone5s) {
        self.tableView.rowHeight = tableViewCellIphone5s_Height;
    } else if (iphone6s) {
        self.tableView.rowHeight = tableViewCellIphone6s_Height;
    } else if (iphone6P) {
        self.tableView.rowHeight = tableViewCellIphone6P_Height;
    } else if (iphone4s) {
        self.tableView.rowHeight = tableViewCellIphone5s_Height;
    }
}

#pragma mark - - - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"消息公告";
        cell.imageView.image = [UIImage imageNamed:@"more_newNotice_icon"];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于我们";
            cell.imageView.image = [UIImage imageNamed:@"more_aboutUs_icon"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"帮助中心";
            cell.imageView.image = [UIImage imageNamed:@"more_helpCenter"];
        } else {
            cell.textLabel.text = @"客户服务";
            cell.detailTextLabel.text = @"工作日 09:00~20:00";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
            cell.imageView.image = [UIImage imageNamed:@"more_customService_phone_icon"];
        }
    } else if (indexPath.section == 2)  {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
            cell.imageView.image = [UIImage imageNamed:@"more_feedback_icon"];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:SGTextFontWith16];
    cell.accessoryType = UITableViewCellStateShowingEditControlMask;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        JCBNewsNoticeVC *newsNVC = [[JCBNewsNoticeVC alloc] init];
        [self.navigationController pushViewController:newsNVC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            JCBAboutUsVC *aboutUsVC = [[JCBAboutUsVC alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        } else if (indexPath.row == 1) {
            JCBHelpCenterVC *helpCVC = [[JCBHelpCenterVC alloc] init];
            [self.navigationController pushViewController:helpCVC animated:YES];
        } else {
            JCBCustomerServiceVC *CSVC = [[JCBCustomerServiceVC alloc] init];
            [self.navigationController pushViewController:CSVC animated:YES];
            /*
            // 联系客服
            UIWebView *phoneNum = [[UIWebView alloc] init];
            phoneNum.frame = CGRectZero;
            NSURL *url = [NSURL URLWithString:@"tel://4000577820"];
            [phoneNum loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:phoneNum];
             */
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            JCBFeedbackVC *feedBVC = [[JCBFeedbackVC alloc] init];
            [self.navigationController pushViewController:feedBVC animated:YES];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return logoff_footView;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *logoff_view = [[UIView alloc] init];
        logoff_view.backgroundColor = SGCommonBgColor;

        self.logoff_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat logoff_btnX = SGMargin;
        CGFloat logoff_btnY = 3 * SGMargin + SGSmallMargin;
        CGFloat logoff_btnW = SG_screenWidth - 2 * SGMargin;
        CGFloat logoff_btnH = 0;
        if (iphone5s) {
            logoff_btnH = SGLoginBtnWithIphone5sHeight;
        } else if (iphone6s) {
            logoff_btnH = SGLoginBtnWithIphone6sHeight;
        } else if (iphone6P) {
            logoff_btnH = SGLoginBtnWithIphone6PHeight;
        } else if (iphone4s) {
            logoff_btnH = SGLoginBtnWithIphone4sHeight;
        }
        
        _logoff_btn.frame = CGRectMake(logoff_btnX, logoff_btnY, logoff_btnW, logoff_btnH);
        [_logoff_btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoff_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         _logoff_btn.backgroundColor = SGCommonRedColor;
        [_logoff_btn addTarget:self action:@selector(logoff_btn_action) forControlEvents:UIControlEventTouchUpInside];
        [SGSmallTool SG_smallWithThisView:_logoff_btn cornerRadius:5];
        [logoff_view addSubview:_logoff_btn];
        
        if (self.isLogin) {
            [logoff_view addSubview:_logoff_btn];
        } else {
            [_logoff_btn removeFromSuperview];
        }
        
        return logoff_view;
        }
    return nil;
}

#pragma mark - - - 退出登录按钮的点击事件
- (void)logoff_btn_action {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/logout", SGCommonURL];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"%@", json);
        if ([json[@"rcd"] isEqualToString:@"R0001"]) {
            SGActionSheet *sheet = [SGActionSheet actionSheetWithTitle:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:@[@"确定"]];
            [sheet show];
        }
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
}

- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在退出中" toView:self.navigationController.view];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.logoff_btn removeFromSuperview];
            self.isLogin = NO;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userAccessToken];
            //[[NSUserDefaults standardUserDefaults] setObject:@"down" forKey:signIn];
            // 立即同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.tabBarController.selectedIndex = 2;
        });
    });
}

#pragma mark - - - 创建版本号提示文字
- (void)setupVersionNumber {
    UILabel *label = [[UILabel alloc] init];
    CGFloat labelX = 0;
    CGFloat labelY = SG_screenHeight * 0.75;
    CGFloat labelW = SG_screenWidth;
    CGFloat labelH = 30;
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[CFBundleVersion];

    SGDebugLog(@"currentVersion - - %@", currentVersion);
    label.text = [NSString stringWithFormat:@"当前版本 V%@", currentVersion];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:SGTextFontWith12];
    label.textColor = SGColorWithDarkGrey;
    //label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
}

- (void)dealloc {
    SGDebugLog(@"JCBMoreVC - - dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


