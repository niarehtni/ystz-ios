//
//  JCBRechargeRecordVC.m
//  JCBJCB
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRechargeRecordVC.h"
#import "JCBRechargeCashTVCell.h"
#import "JCBRechargeCashModel.h"

@interface JCBRechargeRecordVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *allDataSourse;
@end

@implementation JCBRechargeRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"充值记录";
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
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/rechargeList?type=1&pageNumber=%ld&pageSize=10", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"dictionary - - - %@", dictionary);

        self.dataSource_mArr = [JCBRechargeCashModel mj_objectArrayWithKeyValuesArray:dictionary[@"userRechargesList"]];
        [self.tableView reloadData];
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            self.tableView.hidden = YES;
            JCBNoDataView *noDataView = [JCBNoDataView noDataView];
            noDataView.frame = self.view.frame;
            [self.view addSubview:noDataView];
        }
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            //self.tableView.hidden = YES;
            JCBNoDataView *noDataView = [JCBNoDataView noDataView];
            noDataView.frame = self.view.frame;
            [self.view addSubview:noDataView];
        }
        
        int total = [dictionary[@"pageBean"][@"totalCount"] intValue];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/rechargeList?type=1&pageNumber=%ld&pageSize=10", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBRechargeCashModel mj_objectArrayWithKeyValuesArray:json[@"userRechargesList"]];
        
        [self.dataSource_mArr addObjectsFromArray:moreDataSource];
        
        int total = [json[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
            //[self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = SGCommonBgColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBRechargeCashTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBRechargeCashTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    JCBRechargeCashModel *model = self.dataSource_mArr[indexPath.row];
    cell.rechargeRecordModel = model;
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


