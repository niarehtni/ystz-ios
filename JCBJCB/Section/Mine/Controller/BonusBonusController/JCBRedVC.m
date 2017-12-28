//
//  JCBRedVC.m
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRedVC.h"
#import "JCBRedExplainVC.h"
#import "JCBRedTVCell.h"
#import "JCBRedModel.h"
#import "JCBRedDropDownMenuVC.h"

@interface JCBRedVC () <UITableViewDelegate, UITableViewDataSource, RedRightDropDownMenuDelegate, JCBRedDropDownMenuVCDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selection_btn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, assign) NSUInteger selectionIndex;

@property (nonatomic, strong) NSMutableArray *dataSource_mArr;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *allDataSourse;
@property (nonatomic, strong) RedRightDropDownMenu *menu;
@property (nonatomic, strong) JCBNoDataView *noDataView;

@end

@implementation JCBRedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SGCommonBgColor;
    self.dataSource_mArr = [NSMutableArray array];

    [_selection_btn setTitle:@"未使用" forState:(UIControlStateNormal)];
    _selection_btn.titleEdgeInsets = UIEdgeInsetsMake(0, - 40, 0, 0);
    _selection_btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - 75);
    
    [self foundTableView];
    
    // 获取数据
    [self setupRefresh];
}

#pragma mark - - - refresh
- (void)setupRefresh{
    [self.noDataView removeFromSuperview];

    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [SGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSourse)];
}

- (void)loadNewDataSourse {
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/hbListLooked?status=%ld&pageNumber=%ld&pageSize=10", SGCommonURL, self.selectionIndex, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool postAll:urlStr params:nil success:^(id dictionary) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        self.dataSource_mArr = [JCBRedModel mj_objectArrayWithKeyValuesArray:dictionary[@"userHongbaoViews"]];
        SGDebugLog(@"dictionary - - -  %@", dictionary);
        
        if (self.dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            // 没有数据时加载提示 view
            self.noDataView = [JCBNoDataView noDataView];
            CGFloat noDataViewX = 0;
            CGFloat noDataViewY = 44;
            CGFloat noDataViewW = SG_screenWidth;
            CGFloat noDataViewH = SG_screenHeight - noDataViewY;
            _noDataView.frame = CGRectMake(noDataViewX, noDataViewY, noDataViewW, noDataViewH);
            [self.view addSubview:_noDataView];
        }
        
        int total = [dictionary[@"pageBean"][@"totalCount"] intValue];
        if (self.dataSource_mArr.count == total) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/hbListLooked?status=%ld&pageNumber=%ld&pageSize=10", SGCommonURL, self.selectionIndex, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBRedModel mj_objectArrayWithKeyValuesArray:json[@"userHongbaoViews"]];
        
        if (moreDataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        } else if (moreDataSource.count != 0 && moreDataSource.count < [json[@"pageBean"][@"pageSize"] floatValue]) {
            self.tableView.mj_footer.hidden = YES;
            [self.dataSource_mArr addObjectsFromArray:moreDataSource];
        } else {
            [self.dataSource_mArr addObjectsFromArray:moreDataSource];
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
    self.tableView.backgroundColor = SGCommonBgColor;
    self.tableView.rowHeight = 95;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBRedTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

}

- (IBAction)selection_btn_action:(UIButton *)sender {
    if (sender.selected == YES) {
        
    } else {
        
        self.menu = [RedRightDropDownMenu menu];
        _menu.delegate_dropDown = self;
        
        // 2.设置内容
        JCBRedDropDownMenuVC *vc = [[JCBRedDropDownMenuVC alloc] init];
        vc.view.SG_height = SG_screenHeight * 0.22;
        vc.view.SG_width = SG_screenWidth * 0.35;
        _menu.contentController = vc;
        vc.delegate_dropDown = self;
        
        // 3.显示
        [_menu showFrom:sender];
        
    }
}

#pragma mark - - - RightDropDownMenu 代理方法
- (void)dropdownMenuDidDismiss:(RightDropDownMenu *)menu {
    self.selection_btn.selected = NO;
}

- (void)dropdownMenuDidShow:(RightDropDownMenu *)menu {
    self.selection_btn.selected = YES;
}

- (void)dismiss {
    [self.menu dismiss];
}

- (void)JCBRedDropDownMenuVC:(JCBRedDropDownMenuVC *)JCBRedDropDownMenuVC index:(NSUInteger)index title:(NSString *)title {
    [self.selection_btn setTitle:title forState:(UIControlStateNormal)];
    self.selectionIndex = index;
    
    [self setupRefresh];
}

/** 红包说明点击事件 */
- (IBAction)redExplain_btn_action:(id)sender {
    JCBRedExplainVC *redEVC = [[JCBRedExplainVC alloc] init];
    [self.navigationController pushViewController:redEVC animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBRedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    JCBRedModel *model = self.dataSource_mArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
}


@end


