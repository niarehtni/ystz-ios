//
//  JCBProductDetailNextRightVC.m
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailNextRightVC.h"
#import "JCBProductDNRightTVCell.h"
#import "JCBInvestmentRecordModel.h"

@interface JCBProductDetailNextRightVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;
@property (nonatomic, assign) NSUInteger firstPageNumber;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *allDataSourse;
@property (nonatomic, strong) JCBNoDataView *noDataView;

@end

@implementation JCBProductDetailNextRightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrowTenderList/%@&pageNumber=%ld&pageSize=10&orderBy=&orderSort=", SGCommonURL, self.idStr, self.firstPageNumber];
    
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        self.dataSource_mArr = [JCBInvestmentRecordModel mj_objectArrayWithKeyValuesArray:json[@"borrowTenderItemList"]];
        self.allDataSourse = [JCBInvestmentRecordModel mj_objectArrayWithKeyValuesArray:json[@"totalCount"]];
        SGDebugLog(@"json - - -  %@", json);
        [self.tableView reloadData];
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            
            // 没有数据时加载提示 view
            self.noDataView = [JCBNoDataView noDataView];
            CGFloat noDataViewX = 0;
            CGFloat noDataViewY = 0;
            CGFloat noDataViewW = SG_screenWidth;
            CGFloat noDataViewH = SG_screenHeight - noDataViewY;
            _noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewH);
            [self.view addSubview:_noDataView];
        }

        int total = [json[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
            self.tableView.mj_footer.hidden = YES;
        }
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrowTenderList/%@&pageNumber=%ld&pageSize=10&orderBy=&orderSort=", SGCommonURL, self.idStr, self.firstPageNumber];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBInvestmentRecordModel mj_objectArrayWithKeyValuesArray:json[@"borrowTenderItemList"]];
        SGDebugLog(@"json - - -  %@", json);
        [self.dataSource_mArr addObjectsFromArray:moreDataSource];
        
        if (moreDataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }
        
        int total = [json[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
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
    
    UIView *headerView = [[UIView alloc] init];
    CGFloat headerViewX = 0;
    CGFloat headerViewY = 0;
    CGFloat headerViewW = SG_screenWidth;
    CGFloat headerViewH = 30;
    headerView.frame = CGRectMake(headerViewX, headerViewY, headerViewW, headerViewH);

    UILabel *left_label = [[UILabel alloc] init];
    left_label.frame = CGRectMake(SGMargin, 0, 90, headerViewH);
    left_label.text = @"投资人/时间";
    left_label.textAlignment = NSTextAlignmentCenter;
    left_label.textColor = [UIColor lightGrayColor];
    left_label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:left_label];
    UILabel *right_label = [[UILabel alloc] init];
    CGFloat right_leftW = 70;
    CGFloat right_leftH = headerViewH;
    CGFloat right_leftX = SG_screenWidth - right_leftW - SGMargin;
    CGFloat right_leftY = 0;

    right_label.frame = CGRectMake(right_leftX, right_leftY, right_leftW, right_leftH);
    right_label.text = @"金额（元）";
    right_label.textAlignment = NSTextAlignmentRight;
    right_label.textColor = [UIColor lightGrayColor];
    right_label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:right_label];
    headerView.backgroundColor = SGCommonBgColor;
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.rowHeight = 65;
    // 隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDNRightTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBProductDNRightTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    JCBInvestmentRecordModel *model = self.dataSource_mArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;

}



@end

