//
//  JCBHelpCenterVC.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBHelpCenterVC.h"
#import "JCBHelpCenterModel.h"
#import "JCBHelpCenterDetailVC.h"

@interface JCBHelpCenterVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource_arr;

@end

@implementation JCBHelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SGCommonBgColor;
    self.title = @"帮助中心";
    self.dataSource_arr = [NSArray array];
    
    // 配置tableView
    [self foundTableView];
    
    // 获取数据
    [self getDataFromNetWorking];
}

- (void)foundTableView {
    // 注册
    self.tableView.backgroundColor = SGCommonBgColor;
    self.tableView.rowHeight = 60;
    
}

- (void)getDataFromNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    //http://api.hzjcb.com/rest/articleList/app_help_center?pager.pageNumber=1&pager.pageSize=15&way=3
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/articleList/app_help_center?pager.pageNumber=1&pager.pageSize=15&way=3", SGCommonURL];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"%@", json);
        [MBProgressHUD SG_hideHUDForView:self.view];
        self.dataSource_arr = [JCBHelpCenterModel mj_objectArrayWithKeyValuesArray:json[@"articleItemList"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        SGDebugLog(@"%@", error);
    }];
}

#pragma mark - - - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    JCBHelpCenterModel *model = self.dataSource_arr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellStateShowingEditControlMask;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SGMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JCBHelpCenterModel *model = self.dataSource_arr[indexPath.row];
    JCBHelpCenterDetailVC *helpCDVC = [[JCBHelpCenterDetailVC alloc] init];
    helpCDVC.content_id = model.ID;
    helpCDVC.content_title = model.title;
    [self.navigationController pushViewController:helpCDVC animated:YES];
}

@end
