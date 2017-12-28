//
//  JCBInvestmentRecordVC.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBInvestmentRecordVC.h"
#import "JCBInvestmentRecordTVCell.h"
#import "JCBInvestmentRModel.h"
#import "AppDelegate.h"
#import "JCBTabBarController.h"
#import "JCBInvestmentSummaryVC.h"

@interface JCBInvestmentRecordVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;

@end

@implementation JCBInvestmentRecordVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投资记录";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataSource_mArr = [NSMutableArray array];

    [self foundTableView];
    
    // 获取数据
    [self setupRefresh];
    
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItem_action) image:@"navigationButtonReturn" highImage:nil];
}

- (void)leftBarButtonItem_action {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
    appDelegate.window.rootViewController = tabBarC;
    tabBarC.selectedIndex = 2;
}

#pragma mark - - - refresh
- (void)setupRefresh{
    UIView *headerView = [[UIView alloc] init];
    CGFloat headerViewX = 0;
    CGFloat headerViewY = 0;
    CGFloat headerViewW = SG_screenWidth;
    CGFloat headerViewH = 30;
    headerView.frame = CGRectMake(headerViewX, headerViewY, headerViewW, headerViewH);
    
    UILabel *left_label = [[UILabel alloc] init];
    left_label.frame = CGRectMake(SGMargin, 0, 90, headerViewH);
    left_label.text = @"项目/投资时间";
    left_label.textAlignment = NSTextAlignmentCenter;
    left_label.textColor = [UIColor lightGrayColor];
    left_label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:left_label];
    UILabel *right_label = [[UILabel alloc] init];
    CGFloat right_leftW = 120;
    CGFloat right_leftH = headerViewH;
    CGFloat right_leftX = SG_screenWidth - right_leftW - SGMargin;
    CGFloat right_leftY = 0;
    
    right_label.frame = CGRectMake(right_leftX, right_leftY, right_leftW, right_leftH);
    right_label.text = @"投资金额/收益(元)";
    right_label.textAlignment = NSTextAlignmentRight;
    right_label.textColor = [UIColor lightGrayColor];
    right_label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:right_label];
    headerView.backgroundColor = SGCommonBgColor;
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [SGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSourse)];
}

- (void)loadNewDataSourse {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/tzjl?status=&pager.pageNumber=%ld&pager.pageSize=10&orderBy=&orderSort=", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    SGDebugLog(@"urlStr - - %@", urlStr);
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - %@", json);
        self.dataSource_mArr = [JCBInvestmentRModel mj_objectArrayWithKeyValuesArray:json[@"userTenderList"]];
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            //self.tableView.hidden = YES;
            JCBNoDataView *noDataView = [JCBNoDataView noDataView];
            noDataView.frame = self.view.frame;
            [self.view addSubview:noDataView];
        }
        
        int total = [json[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
            //[self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView reloadData];
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"error - - -  %@", error);
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 数据加载失败隐藏刷新功能
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
    }];
    
}

- (void)loadMoreDataSourse {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    self.firstPageNumber += 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/tzjl?status=&pager.pageNumber=%ld&pager.pageSize=10&orderBy=&orderSort=", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBInvestmentRModel mj_objectArrayWithKeyValuesArray:json[@"userTenderList"]];
        
        [self.dataSource_mArr addObjectsFromArray:moreDataSource];
        
        if (moreDataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView reloadData];
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"error - - -  %@", error);
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 数据加载失败隐藏刷新功能
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
    }];
    
}

- (void)foundTableView {
    
    // 隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = SGCommonBgColor;
    self.tableView.rowHeight = 70;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBInvestmentRecordTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBInvestmentRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    JCBInvestmentRModel *model = self.dataSource_mArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBInvestmentRModel *model = self.dataSource_mArr[indexPath.row];
    if ([model.borrowStatusShow isEqualToString:@"等待复审"]) {
        SGAlertView *alertV = [SGAlertView alertViewWithTitle:nil contentTitle:@"等待项目复审" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne) didSelectedBtnIndex:^(SGAlertView *alertView, NSInteger index) {
            if (index == 0) {
                
            } else {
                
            }
        }];
        [alertV show];
    } else if ([model.borrowStatusShow isEqualToString:@"还款中"]) {
        JCBInvestmentSummaryVC *summaryVC = [[JCBInvestmentSummaryVC alloc] init];
        summaryVC.bid_id = model.tenderid;
        summaryVC.investment_title = model.borrowName;
        [self.navigationController pushViewController:summaryVC animated:YES];
    } else {
        JCBInvestmentSummaryVC *summaryVC = [[JCBInvestmentSummaryVC alloc] init];
        summaryVC.bid_id = model.tenderid;
        summaryVC.investment_title = model.borrowName;
        [self.navigationController pushViewController:summaryVC animated:YES];
    }
}


@end
