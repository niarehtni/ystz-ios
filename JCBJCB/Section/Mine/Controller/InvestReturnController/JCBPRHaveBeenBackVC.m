//
//  JCBPRHaveBeenBackVC.m
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBPRHaveBeenBackVC.h"
#import "JCBPayBackTVCell.h"
#import "JCBPayBackModel.h"

@interface JCBPRHaveBeenBackVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *allDataSourse;
@property (nonatomic, strong) JCBNoDataView *noDataView;
@end

@implementation JCBPRHaveBeenBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    NSInteger type = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/hkmx?status=%ld&pager.pageNumber=%ld&pager.pageSize=400", SGCommonURL, type, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - %@", json);
        self.dataSource_mArr = [JCBPayBackModel mj_objectArrayWithKeyValuesArray:json[@"userRepaymentList"]];
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            //self.tableView.hidden = YES;
            self.noDataView = [JCBNoDataView noDataView];
            CGFloat noDataViewX = 0;
            CGFloat noDataViewY = 44;
            CGFloat noDataViewW = SG_screenWidth;
            CGFloat noDataViewH = SG_screenHeight - noDataViewY;
            _noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewH);
            [self.view addSubview:_noDataView];
        }
        
        int total = [json[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
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
    NSInteger type = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/hkmx?status=%ld&pager.pageNumber=%ld&pager.pageSize=400", SGCommonURL, type, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBPayBackModel mj_objectArrayWithKeyValuesArray:json[@"userRepaymentList"]];
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
    
    // 隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = SGCommonBgColor;
    self.tableView.rowHeight = 80;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBPayBackTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBPayBackTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JCBPayBackModel *model = self.dataSource_mArr[indexPath.row];
    cell.backModel = model;
    
    return cell;
}



@end


