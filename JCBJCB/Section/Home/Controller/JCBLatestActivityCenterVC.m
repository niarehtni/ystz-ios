//
//  JCBLatestActivityCenterVC.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBLatestActivityCenterVC.h"
#import "JCBLatestActivityCenterTVCell.h"
#import "JCBLatestActivityCenterModel.h"
#import "JCBLatestActivityVC.h"

@interface JCBLatestActivityCenterVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;

@end

@implementation JCBLatestActivityCenterVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"活动中心";
    self.view.backgroundColor = SGCommonBgColor;
    self.dataSource_mArr = [NSMutableArray array];

    
    [self foundTableView];
    
    // 获取数据
    [self setupRefresh];
}

#pragma mark - - - refresh
- (void)setupRefresh{
    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [SGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSourse)];
}

- (void)loadNewDataSourse {
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/activity?pager.pageNumber=%ld&pager.pageSize=150", SGCommonURL, self.firstPageNumber];
    //urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    SGDebugLog(@"urlStr - - - %@", urlStr);
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        self.dataSource_mArr = [JCBLatestActivityCenterModel mj_objectArrayWithKeyValuesArray:json[@"activityList"]];
        SGDebugLog(@"self.dataSource_mArr - - -  %@", json);
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
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView reloadData];
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"error - - -  %@", error);
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 数据加载失败隐藏刷新功能
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
    }];
    
}
     
- (void)loadMoreDataSourse {
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    self.firstPageNumber += 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/activity?pager.pageNumber=%ld&pager.pageSize=150", SGCommonURL, self.firstPageNumber];
    //urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    SGDebugLog(@"urlStr - - - 2 2 2 - - - %@", urlStr);

    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBLatestActivityCenterModel mj_objectArrayWithKeyValuesArray:json[@"activityList"]];
        [self.dataSource_mArr addObjectsFromArray:moreDataSource];
        
        if (moreDataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView reloadData];
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
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
    self.tableView.rowHeight = 190;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBLatestActivityCenterTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBLatestActivityCenterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JCBLatestActivityCenterModel *model = self.dataSource_mArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBLatestActivityCenterModel *model = self.dataSource_mArr[indexPath.row];
    JCBLatestActivityVC *LAVC = [[JCBLatestActivityVC alloc] init];
    LAVC.content_id = model.ID;
    [self.navigationController pushViewController:LAVC animated:YES];
}

@end
