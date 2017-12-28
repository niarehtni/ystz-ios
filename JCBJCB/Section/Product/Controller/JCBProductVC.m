//
//  JCBProductVC.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductVC.h"
#import "JCBProductTVCell.h"
#import "JCBProductModel.h"
#import "DOPDropDownMenu.h"
#import "JCBProductDetailVC.h"

@interface JCBProductVC () <UITableViewDelegate, UITableViewDataSource, DOPDropDownMenuDelegate, DOPDropDownMenuDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;

@property (nonatomic, strong) NSArray *productType_arr;
@property (nonatomic, strong) NSMutableDictionary *productType_mDic;
@property (nonatomic, copy) NSString *productType_currentStr;

@property (nonatomic, strong) NSArray *projectDuration_arr;
@property (nonatomic, strong) NSMutableDictionary *projectDuration_mDic;
@property (nonatomic, copy) NSString *projectDuration_currentStr;

@property (nonatomic, strong) NSArray *timeSort_arr;
@property (nonatomic, strong) NSMutableDictionary *timeSort_mDic;
@property (nonatomic, copy) NSString *timeSort_currentStr;

@property (nonatomic, strong) DOPDropDownMenu *DOPDDMenu;
@property (nonatomic, strong) JCBNoDataView *noDataView;
@property (nonatomic, assign) NSUInteger firstPageNumber;

@property (nonatomic, assign) BOOL isLogin;

@end

@implementation JCBProductVC

static CGFloat const DOPDDMenuHeight = 44;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取数据
    [self setupRefresh];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:signIn];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:comeFromTabbarIndex];
    // 立即同步
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"产品列表";
    self.view.backgroundColor = SGCommonBgColor;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataSource_mArr = [NSMutableArray array];

    
    [self foundDOPDropDownMenu];
    
    [self foundTableView];
    
    // 获取数据
    //[self setupRefresh];
    
}

- (void)foundDOPDropDownMenu {
    // 项目类型
    self.productType_arr = @[@"产品类型", @"新手标"];
    
    self.productType_mDic = [NSMutableDictionary dictionary];
    NSArray *typeID_arr = @[@"", @"16"];
    for (int i = 0; i < _productType_arr.count; i++) {
        [self.productType_mDic setObject:typeID_arr[i] forKey:_productType_arr[i]];
    }
    self.productType_currentStr = @"";
    
    
    // 项目期限
    self.projectDuration_arr = @[@"期限不限", @"0-30天", @"30-90天", @"90-180天", @"180-360天", @"360天以上"];
    
    self.projectDuration_mDic = [NSMutableDictionary dictionary];
    NSArray *timeID_arr = @[@"0", @"1", @"2", @"3", @"4", @"5"];
    for (int i = 0; i < _projectDuration_arr.count; i++) {
        [self.projectDuration_mDic setObject:timeID_arr[i] forKey:_projectDuration_arr[i]];
    }
    self.projectDuration_currentStr = @"";
    
    
    // 默认排序
    self.timeSort_arr = @[@"时间排序", @"时间正序", @"时间倒序"];
    
    self.timeSort_mDic = [NSMutableDictionary dictionary];
    NSArray *sortID_arr = @[@"", @"1", @"0"];
    for (int i = 0; i < _timeSort_arr.count; i++) {
        [self.timeSort_mDic setObject:sortID_arr[i] forKey:_timeSort_arr[i]];
    }
    self.timeSort_currentStr = @"";
    
    
    self.DOPDDMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:DOPDDMenuHeight];
    _DOPDDMenu.delegate = self;
    _DOPDDMenu.dataSource = self;
    [self.view addSubview:_DOPDDMenu];
}

#pragma mark - DOPDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return _productType_arr.count;
    } else if (column == 1) {
        return _projectDuration_arr.count;
    } else if (column == 2) {
        return _timeSort_arr.count;
    } else {
        return 0;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return _productType_arr[indexPath.row];
    } else if (indexPath.column == 1) {
        return _projectDuration_arr[indexPath.row];
    } else if (indexPath.column == 2) {
        return _timeSort_arr[indexPath.row];
    } else {
        return nil;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {

    if (indexPath.column == 0) {
        self.productType_currentStr = [self.productType_mDic objectForKey:self.productType_arr[indexPath.row]];
    } else if (indexPath.column == 1) {
        self.projectDuration_currentStr = [self.projectDuration_mDic objectForKey:self.projectDuration_arr[indexPath.row]];
    } else if (indexPath.column == 2) {
        self.timeSort_currentStr = [self.timeSort_mDic objectForKey:self.timeSort_arr[indexPath.row]];
    }
    
    //[self loadNewDataSourseWithDOPDropDownMenu];
    [self setupRefresh];
}

- (void)loadNewDataSourseWithDOPDropDownMenu {
    self.firstPageNumber = 1;
    [self.tableView.mj_header beginRefreshing];
    [self loadNewDataSourse];
}

#pragma mark - - - foundTableView
- (void)foundTableView {
    CGFloat tableViewH = SG_screenHeight - 49 - navigationAndStatusBarHeight - DOPDDMenuHeight;
    self.tableView = [[JCBTableView alloc] initWithFrame:CGRectMake(0, DOPDDMenuHeight, SG_screenWidth, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = SGCommonBgColor;
    _tableView.rowHeight = 180;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

    [self.view addSubview:_tableView];
}


#pragma mark - - - refresh
- (void)setupRefresh{
    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [SGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSourse)];
}

- (void)loadNewDataSourse {
    
    if (self.noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrow?businessType=%@&limitLevel=%@&pager.pageNumber=%ld&pager.pageSize=10&orderBy=&desc=%@", SGCommonURL, self.productType_currentStr, self.projectDuration_currentStr, self.firstPageNumber, self.timeSort_currentStr];
    SGDebugLog(@"urlStr - - - %@", urlStr);
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        self.dataSource_mArr = [JCBProductModel mj_objectArrayWithKeyValuesArray:json[@"borrowItemList"]];
        SGDebugLog(@"json - - -  %@", json);
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            
            self.noDataView = [JCBNoDataView noDataView];
            _noDataView.frame = self.view.frame;
            [self.view addSubview:_noDataView];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrow?businessType=%@&limitLevel=%@&pager.pageNumber=%ld&pager.pageSize=10&orderBy=&desc=%@", SGCommonURL, self.productType_currentStr, self.projectDuration_currentStr, self.firstPageNumber, self.timeSort_currentStr];
    
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        NSArray *moreDataSource = [JCBProductModel mj_objectArrayWithKeyValuesArray:json[@"borrowItemList"]];
        SGDebugLog(@"json - - -  %@", json);
        [self.dataSource_mArr addObjectsFromArray:moreDataSource];
        
        [self.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"error - - -  %@", error);
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBProductTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    JCBProductModel *model = self.dataSource_mArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
    JCBProductModel *model = self.dataSource_mArr[indexPath.row];
    JCBProductDetailVC *productDVC = [[JCBProductDetailVC alloc] init];
    productDVC.idStr = model.ID;
    productDVC.scheduleIs100 = model.schedule;
    [self.navigationController pushViewController:productDVC animated:YES];
}


- (void)dealloc {
    SGDebugLog(@"JCBProductVC - - dealloc");
}

@end


