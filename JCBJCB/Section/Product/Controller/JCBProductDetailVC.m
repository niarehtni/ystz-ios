//
//  JCBProductDetailVC.m
//  JCBJCB
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailVC.h"
#import "JCBProductDetailTopTVCell.h"
#import "JCBProductDetailBottomTVCell.h"
#import "JCBProductDetailTextTVCell.h"
#import "JCBProductDetailModel.h"
#import "JCBImmediateInvestmentVC.h"
#import "JCBProductDetailNextVC.h"
#import "JCBLoginRegisterVC.h"
#import "JCBBingCardAuthenticationVC.h"

@interface JCBProductDetailVC () <UITableViewDelegate, UITableViewDataSource, SGAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *bottom_btn;
@property (nonatomic, strong) NSDictionary *dataSource_dic;
@property (nonatomic, strong) NSDictionary *dataSource_dict;
@property (nonatomic, strong) NSDictionary *dataSource_dic_login;
@property (nonatomic, strong) NSDictionary *dataSource_dic_isNew;

@end

@implementation JCBProductDetailVC

// static CGFloat const panGRMiniTranslation = 30.0;
static CGFloat const bottomButtonHeight = 50.0;

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 利用生命周期设置是否隐藏 navigationBar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"userCenter - dictionary - - - %@", dictionary);
        self.dataSource_dic_login = dictionary;
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
    
#pragma mark - - - 判断用户是不是新手投标
    NSString *newUrlStr = [NSString stringWithFormat:@"%@/rest/poputInvest/%@", SGCommonURL, self.idStr];
    newUrlStr = [newUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:newUrlStr];
    
    [SGHttpTool postAll:newUrlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"poputInvest - dictionary - - %@", dictionary);
        self.dataSource_dic_isNew = dictionary;
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - %@", error);
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目详情";
    self.view.backgroundColor = SGCommonBgColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItem_action) image:@"login_register_backImage" highImage:nil];
    
    [self foundTableView];
    [self setupBottomButton];
    
    // 获取数据
    [self getDataFromNetWorking];

}

- (void)leftBarButtonItem_action {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataFromNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrow/%@", SGCommonURL, self.idStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"borrow - json - - - %@", json);
        [MBProgressHUD SG_hideHUDForView:self.view];
        self.dataSource_dic = json;
        self.dataSource_dict = json;
        
        //SGLog(@"idStr - - %@", self.idStr);

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        SGDebugLog(@"%@", error);
    }];
}

- (void)foundTableView {
    self.tableView = [[JCBTableView alloc] initWithFrame:CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - bottomButtonHeight) style:(UITableViewStylePlain)];
    _tableView.backgroundColor = SGCommonBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // 注册
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDetailTopTVCell class]) bundle:nil] forCellReuseIdentifier:@"topCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDetailBottomTVCell class]) bundle:nil] forCellReuseIdentifier:@"bottomCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDetailTextTVCell class]) bundle:nil] forCellReuseIdentifier:@"textCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *twoSection_arr = @[@"计息方式", @"保障方式", @"还款方式", @"发布时间"];
    
    if (indexPath.section == 0) {
        JCBProductDetailTopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.backBtn addTarget:self action:@selector(leftBarButtonItem_action) forControlEvents:(UIControlEventTouchUpInside)];
        JCBProductDetailModel *model = [[JCBProductDetailModel alloc] initWithDictionary:self.dataSource_dic];
        cell.model = model;
        return cell;
    } else if (indexPath.section == 1) {
        JCBProductDetailBottomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.leftLabel.text = twoSection_arr[indexPath.row];
        
        JCBProductDetailModel *model = [[JCBProductDetailModel alloc] initWithDictionary:self.dataSource_dic];
        if (indexPath.row == 0) {
            cell.rightLabel.text = @"满标审核后当天计息";
        } else if (indexPath.row == 1) {
            cell.rightLabel.text = @"1 抵押  2 质押  3 担保";
        } else if (indexPath.row == 2) {
            cell.rightLabel.text = model.styleName;
        } else if (indexPath.row == 3) {
            cell.rightLabel.text = [self getPublishTimeBy:[NSString stringWithFormat:@"%f", model.verifyTime]];
        }

        return cell;
    } else {
        JCBProductDetailTextTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = SGCommonBgColor;
        return cell;
    }
}

- (NSString *)getPublishTimeBy:(NSString *)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *cesh111 = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue] / 1000];
    NSString *shijian = [formatter stringFromDate:cesh111];
    return shijian;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 0.01;
    } else {
        return SGMargin;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tableViewHeight = SG_screenHeight - 2 * bottomButtonHeight;
    CGFloat topCellHeight = tableViewHeight * 0.56;
    if (indexPath.section == 0) {
        return topCellHeight;
    } else if (indexPath.section == 1) {
        return (tableViewHeight - topCellHeight - 10) / 4;
    } else {
        return bottomButtonHeight;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY >= 50) {
        JCBProductDetailNextVC *productDetailNextVC = [[JCBProductDetailNextVC alloc] init];
        productDetailNextVC.idString = self.idStr;
        UINavigationController *newNavigationC = [[UINavigationController alloc] initWithRootViewController:productDetailNextVC];
        // 模态导航控制器
        [self presentViewController:newNavigationC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - - - 创建底部Button
- (void)setupBottomButton {
    self.bottom_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat bottom_btnW = SG_screenWidth;
    CGFloat bottom_btnH = bottomButtonHeight;
    CGFloat bottom_btnX = 0;
    CGFloat bottom_btnY = SG_screenHeight - bottomButtonHeight;
    _bottom_btn.frame = CGRectMake(bottom_btnX, bottom_btnY, bottom_btnW, bottom_btnH);
    if (self.scheduleIs100 == 100) {
        _bottom_btn.backgroundColor = SGColorWithDarkGrey;
        [_bottom_btn setTitle:@"投资其他项目" forState:(UIControlStateNormal)];
    } else {
        _bottom_btn.backgroundColor = SGColorWithRGB(238, 80, 87);
        [_bottom_btn setTitle:@"立即投资" forState:(UIControlStateNormal)];
    }
    [_bottom_btn addTarget:self action:@selector(bottom_Btn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_bottom_btn];
}

#pragma mark - - - 底部按钮的点击事件 － 立即投资按钮
- (void)bottom_Btn_action {
    SGDebugLog(@"bottom_Btn_action");
    
    if (self.scheduleIs100 == 100) {
        [self.navigationController popViewControllerAnimated:YES];
        
#pragma mark - - - 判断是不是新手
    } else if ([self.dataSource_dic_isNew[@"rcd"] isEqualToString:@"M0007_12"]) { // 后台返回的 Boolean 属性， 判断是不是新手 [self.dataSource_dic_isNew[@"tenderStatus"] boolValue] == 1
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", self.dataSource_dic_isNew[@"rmg"]] delayTime:1.5];
    } else {
    
        if ([self.dataSource_dic_login[@"rcd"] isEqualToString:@"E0001"]) {
            SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"提示" delegate:self contentTitle:@"登录后才能进行投资，是否立即登录" alertViewBottomViewType:(SGAlertViewBottomViewTypeTwo)];
            alertView.sure_btnTitle = @"登录";
            [alertView show];
        } else if ([self.dataSource_dic_login[@"rcd"] isEqualToString:@"R0001"]) {
            JCBImmediateInvestmentVC *IIVC = [[JCBImmediateInvestmentVC alloc] init];
            //IIVC.dataSource_dict_borrow = self.dataSource_dict;
            IIVC.valueID = self.idStr;
            SGDebugLog(@"IIVC.valueID - - - %@", IIVC.valueID);
            [self.navigationController pushViewController:IIVC animated:YES];
        }

    }
}


#pragma mark - - - SGAlertViewDelegate
- (void)didSelectedLeftButtonClick {
    
}

- (void)didSelectedRightButtonClick {
    [JCBSingletonManager sharedSingletonManager].isProductDetailLogin = YES;
    // 立即同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    JCBLoginRegisterVC * loginRegisterVC = [[JCBLoginRegisterVC alloc] init];
    UINavigationController *newNavigationC = [[UINavigationController alloc] initWithRootViewController:loginRegisterVC];
    // 模态导航控制器
    [self presentViewController:newNavigationC animated:YES completion:^{
        
    }];
}










@end
