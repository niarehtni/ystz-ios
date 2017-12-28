//
//  JCBRewardVC.m
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRewardVC.h"
#import "JCBRewardExplainVC.h"
#import "JCBRewardTVCell.h"
#import "JCBRewardModel.h"

@interface JCBRewardVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *allDataSourse;
@end

@implementation JCBRewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SGCommonBgColor;

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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/awardCash?pageNumber=%ld&pageSize=10", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

        self.dataSource_mArr = [JCBRewardModel mj_objectArrayWithKeyValuesArray:dictionary[@"cashList"]];
        SGDebugLog(@"dictionary - - -  %@", dictionary);
        [self.tableView reloadData];
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            //self.tableView.hidden = YES;
            // 没有数据时加载提示 view
            JCBNoDataView *noDataView = [JCBNoDataView noDataView];
            CGFloat noDataViewX = 0;
            CGFloat noDataViewY = 44;
            CGFloat noDataViewW = SG_screenWidth;
            CGFloat noDataViewH = SG_screenHeight - noDataViewY;
            noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewH);
            [self.view addSubview:noDataView];
        }
        
        int total = [dictionary[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
            self.tableView.mj_footer.hidden = YES;
        }
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/awardCash?pageNumber=%ld&pageSize=10", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBRewardModel mj_objectArrayWithKeyValuesArray:json[@"userHongbaoItem"]];
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
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor = SGCommonBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBRewardTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBRewardTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    JCBRewardModel *model = self.dataSource_mArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
}

/** 奖励说明点击事件 */
- (IBAction)rewardExplain_btn_action:(id)sender {
    JCBRewardExplainVC *rewardEVC = [[JCBRewardExplainVC alloc] init];
    [self.navigationController pushViewController:rewardEVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
