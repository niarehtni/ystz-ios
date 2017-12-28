//
//  JCBProductRedVC.m
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductRedVC.h"
#import "JCBProductRedTVCell.h"
#import "JCBProductRedModel.h"
#import "JCBRedExplainVC.h"

@interface JCBProductRedVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *chioseRedMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBidMoneyLabel;
@property (nonatomic, strong) NSArray *dataSource_canUseRed;
@property (nonatomic, strong) NSArray *dataSource_canUnUseRed;
/** 用于接收最外层字典 */
@property (nonatomic, strong) NSDictionary *dataSource_dict;
/** 用于接收红包数组 */
@property (nonatomic, strong) NSMutableArray *dataSource_mArr;

@property (nonatomic, strong) NSMutableArray *dataSource_newMArr;
/** 存储最优红包数 ID（以后存储选中的红包数） */
@property (nonatomic, strong) NSMutableArray *all_red_ID_mArr;
/** 存储最优红包数 ID */
@property (nonatomic, strong) NSMutableArray *canUse_red_ID_mArr;
/** 存储没有选中红包数 ID */
@property (nonatomic, strong) NSMutableArray *unCanUse_red_ID_mArr;
/** 存储最优红包数 investFullMomey */
@property (nonatomic, strong) NSMutableArray *all_redInvestFullMomey_mArr;
/** 存储最优红包数（以后存储选中的红包数） investFullMomey 元素和 */
@property (nonatomic, copy) NSString *all_redInvestFullMomey_sum_str;
/** 记录最优红包数 investFullMomey 元素和 */
@property (nonatomic, copy) NSString *first_redInvestFullMomey_sum_str;
/** 记录已选红包的钱数 */
@property (nonatomic, copy) NSString *sportMoney;
// 记录新增金钱数
@property (nonatomic, assign) CGFloat newAddMoney;

@end

@implementation JCBProductRedVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getDataFromNetWorking];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"红包选择";
    self.view.backgroundColor = SGCommonBgColor;
    self.dataSource_canUseRed = [NSArray array];
    self.dataSource_canUnUseRed = [NSArray array];
    self.all_red_ID_mArr = [@[] mutableCopy];
    self.canUse_red_ID_mArr = [@[] mutableCopy];
    self.unCanUse_red_ID_mArr = [@[] mutableCopy];
    self.all_redInvestFullMomey_mArr = [@[] mutableCopy];
    
    self.dataSource_newMArr = [@[] mutableCopy];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItem_action) title:@"红包说明" titleColor:[UIColor blackColor] titleFond:[UIFont systemFontOfSize:SGTextFontWith13]];
    [self foundTableView];
    
}

- (void)rightBarButtonItem_action {
    SGDebugLog(@"rightBarButtonItem_action");
    JCBRedExplainVC *redExplainVC = [[JCBRedExplainVC alloc] init];
    [self.navigationController pushViewController:redExplainVC animated:YES];
}

- (void)getDataFromNetWorking {

    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/hbListBestH", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"investFullMomeyMax"] = [NSString stringWithFormat:@"%@", self.bidMoneyStr];
    params[@"borrowId"] = self.bidIDStr;

    [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
        SGDebugLog(@"dictionary - - - %@", dictionary);
        [MBProgressHUD SG_hideHUDForView:self.view];//userHongbaoList
        self.dataSource_dict = dictionary;
        self.dataSource_mArr = [JCBProductRedModel mj_objectArrayWithKeyValuesArray:dictionary[@"userHongbaoList"]];

        NSString *rangeStr = dictionary[@"bestNum"]; // 全部为可用红包
        if (self.dataSource_mArr.count != 0 && self.dataSource_mArr.count == [rangeStr integerValue]) {
            self.dataSource_canUseRed = [JCBProductRedModel mj_objectArrayWithKeyValuesArray:dictionary[@"userHongbaoList"]];
            // 遍历最优红包数组
            for (int i = 0; i < self.dataSource_canUseRed.count; i++) {
                JCBProductRedModel *model = self.dataSource_canUseRed[i];
                // 存储最优红包数组 ID
                [self.all_red_ID_mArr addObject:model.ID];
                // 存储最优红包数组 investFullMomey
                [self.all_redInvestFullMomey_mArr addObject:model.investFullMomey];
                // 让最优红包数组选中
                if ([model.on isEqualToString:@"1"]) {
                    model.isSelected = YES;
                }
            }
            // 求数组中所有元素的和
            NSNumber *sum = [self.all_redInvestFullMomey_mArr valueForKeyPath:@"@sum.floatValue"];
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%@", sum];
            self.first_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%@", sum];
            
        } else if ([rangeStr integerValue] == 0) { // 全部为不可用红包
            self.dataSource_canUseRed = 0;
            self.dataSource_canUnUseRed = [JCBProductRedModel mj_objectArrayWithKeyValuesArray:dictionary[@"userHongbaoList"]];;
        } else { // 既有可用红包又有不可用红包
            self.dataSource_canUseRed = [self.dataSource_mArr subarrayWithRange:NSMakeRange(0, [rangeStr integerValue])];
            self.dataSource_canUnUseRed = [self.dataSource_mArr subarrayWithRange:NSMakeRange([rangeStr integerValue], self.dataSource_mArr.count - [rangeStr integerValue])];
            
            // 遍历最优红包数组
            for (int i = 0; i < self.dataSource_canUseRed.count; i++) {
                JCBProductRedModel *model = self.dataSource_canUseRed[i];
                // 存储最优红包数组 ID
                [self.all_red_ID_mArr addObject:model.ID];
                [self.canUse_red_ID_mArr addObject:model.ID];
                // 存储最优红包数组 investFullMomey
                [self.all_redInvestFullMomey_mArr addObject:model.investFullMomey];
                // 让最优红包数组选中
                if ([model.on isEqualToString:@"1"]) {
                    model.isSelected = YES;
                }
            }
            
            // 求数组中所有元素的和
            NSNumber *sum = [self.all_redInvestFullMomey_mArr valueForKeyPath:@"@sum.floatValue"];
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%@", sum];
            self.first_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%@", sum];
            
            // 遍历没有使用到的红包数组
            for (int j = 0; j < self.dataSource_canUnUseRed.count; j++) {
                JCBProductRedModel *model = self.dataSource_canUnUseRed[j];
                // 取消按钮的选中状态
                if ([model.on isEqualToString:@"0"]) {
                    model.isSelected = NO;
                }
            }
        }
        
        self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [dictionary[@"bestHbMoney"] floatValue]];
        // 记录已选红包的钱数
        self.sportMoney = dictionary[@"bestHbMoney"];
        if ([self.bidMoneyStr isEqualToString:@""]) {
            self.currentBidMoneyLabel.text = @"0元";
        } else {
            self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%@元", self.bidMoneyStr];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"%@", error);
    }];
}

#pragma mark - - - tableView 及其代理
- (void)foundTableView {
    _tableView.rowHeight = redCellHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource_mArr.count == [self.dataSource_dict[@"bestNum"] integerValue] || [self.dataSource_dict[@"bestNum"] integerValue] == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource_mArr.count == [self.dataSource_dict[@"bestNum"] integerValue]) {
        return self.dataSource_canUseRed.count;
    } else if ([self.dataSource_dict[@"bestNum"] integerValue] == 0) {
        return self.dataSource_canUnUseRed.count;
    } else {
        if (section == 0) {
            return self.dataSource_canUseRed.count;
        } else {
            return self.dataSource_canUnUseRed.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataSource_mArr.count == [self.dataSource_dict[@"bestNum"] integerValue] && self.dataSource_mArr.count != 0) { // 全部为可用红包
        JCBProductRedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[JCBProductRedTVCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JCBProductRedModel *model = self.dataSource_canUseRed[indexPath.row];
        cell.model = model;
        cell.selectedBtn.tag = indexPath.row;
        [cell.selectedBtn addTarget:self action:@selector(selectedBtn_action:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;

    } else if ([self.dataSource_dict[@"bestNum"] integerValue] == 0 && self.dataSource_canUnUseRed.count != 0) { // 全部为不可用红包
        
        JCBProductRedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uncell"];
        if (!cell) {
            cell = [[JCBProductRedTVCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"uncell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.selectedBtn addTarget:self action:@selector(selectedBtn_action_section:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.selectedBtn.tag = indexPath.row;
        JCBProductRedModel *model = self.dataSource_canUnUseRed[indexPath.row];
        cell.unUseModel = model;
        return cell;

    } else { // 既有可用红包又有不可用红包
        
        if (indexPath.section == 0) {
            JCBProductRedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[JCBProductRedTVCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            JCBProductRedModel *model = self.dataSource_canUseRed[indexPath.row];
            cell.model = model;
            cell.selectedBtn.tag = indexPath.row;
            [cell.selectedBtn addTarget:self action:@selector(selectedBtn_action:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
            
        } else {
            
            JCBProductRedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uncell"];
            if (!cell) {
                cell = [[JCBProductRedTVCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"uncell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.selectedBtn addTarget:self action:@selector(selectedBtn_action_section:) forControlEvents:(UIControlEventTouchUpInside)];
            cell.selectedBtn.tag = indexPath.row;
            JCBProductRedModel *unUseModel = self.dataSource_canUnUseRed[indexPath.row];
            cell.unUseModel = unUseModel;
            cell.selectedBtn.tag = indexPath.row;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSource_mArr.count == [self.dataSource_dict[@"bestNum"] integerValue] || [self.dataSource_dict[@"bestNum"] integerValue] == 0) {
        return 0.01;
    } else {
        if (section == 0) {
            return 0.01;
        } else {

            return 2 * SGMargin;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataSource_mArr.count == [self.dataSource_dict[@"bestNum"] integerValue] || [self.dataSource_dict[@"bestNum"] integerValue] == 0) {
        return 0.01;
    } else {
        if (section == 0) {
            return SGMargin;
        } else {
            return 0.01;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource_mArr.count == [self.dataSource_dict[@"bestNum"] integerValue]  || [self.dataSource_dict[@"bestNum"] integerValue] == 0) {
        return nil;
    } else {
        if (section == 0) {
            return nil;
        } else {
            UIView *view = [[UIView alloc] init];
            
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:SGTextFontWith14];
            label.textColor = SGColorWithDarkGrey;
            label.text = @"若您想使用其余红包，则需要增加投资金额";
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(0, 0, SG_screenWidth, 2 * SGMargin);
            [view addSubview:label];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
    }
}

#pragma mark - - - 最优红包分区点击事件
- (void)selectedBtn_action:(UIButton *)button {
    JCBProductRedModel *model = self.dataSource_canUseRed[button.tag];
    model.isSelected = !model.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    if (model.isSelected) {
        if (self.unCanUse_red_ID_mArr.count == 0) { // 没有增加投资的金钱
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [model.money floatValue];
            CGFloat result = one + two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr addObject:model.ID];
            [self.canUse_red_ID_mArr addObject:model.ID];
            
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", [self.all_redInvestFullMomey_sum_str floatValue] + [model.investFullMomey floatValue]];
        } else { // 有增加投资的金钱
            
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [model.money floatValue];
            CGFloat result = one + two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr addObject:model.ID];
            [self.canUse_red_ID_mArr addObject:model.ID];

            // 新增投资金钱数
            CGFloat sum = [model.investFullMomey floatValue];
            CGFloat oldMoney = [self.all_redInvestFullMomey_sum_str floatValue];
            
            if (oldMoney == [self.all_redInvestFullMomey_sum_str floatValue]) {
                self.newAddMoney = sum;
                NSString *tempStr = [NSString stringWithFormat:@"需要新增%.f元", self.newAddMoney];
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:tempStr delayTime:1.0];
                self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", sum + oldMoney];
            } else {
                CGFloat newAddMoney = sum - oldMoney;
                self.newAddMoney = newAddMoney;
                NSString *tempStr = [NSString stringWithFormat:@"需要新增%.f元", newAddMoney];
                if (sum != oldMoney) {
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:tempStr delayTime:1.0];
                }
                self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", sum + oldMoney];
            }
            
            self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%@元", self.all_redInvestFullMomey_sum_str];
        }
        
    } else {

        if (self.unCanUse_red_ID_mArr.count == 0) { // 没有增加投资的金钱
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [model.money floatValue];
            CGFloat result = one - two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr removeObject:model.ID];
            [self.canUse_red_ID_mArr removeObject:model.ID];
            
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", [self.all_redInvestFullMomey_sum_str floatValue] - [model.investFullMomey floatValue]];
        } else { // 有增加投资的金钱
            
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [model.money floatValue];
            CGFloat result = one - two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr removeObject:model.ID];
            [self.unCanUse_red_ID_mArr removeObject:model.ID];
            
            
            CGFloat oldMoney = [self.all_redInvestFullMomey_sum_str floatValue];
            // 新增投资金钱数
            CGFloat lastMoney = oldMoney - [model.investFullMomey floatValue];
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", lastMoney];
            if (lastMoney == [self.bidMoneyStr floatValue]) {
                self.all_redInvestFullMomey_sum_str = self.first_redInvestFullMomey_sum_str;
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.all_redInvestFullMomey_sum_str floatValue]];
                return;
            }
            
            if ([self.all_redInvestFullMomey_sum_str floatValue] <= [self.bidMoneyStr floatValue]) {
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.bidMoneyStr floatValue]];
            } else {
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.all_redInvestFullMomey_sum_str floatValue]];
            }
        }
        
    }
}


#pragma mark - - - 需要增加投资分区
- (void)selectedBtn_action_section:(UIButton *)button {
    JCBProductRedModel *unUseModel = self.dataSource_canUnUseRed[button.tag];
    unUseModel.isSelected = !unUseModel.isSelected;
    
    if ([self.dataSource_dict[@"bestNum"] integerValue] == 0) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (unUseModel.isSelected) {
        if (self.canUse_red_ID_mArr.count == 0) { // 没有最优红包数
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [unUseModel.money floatValue];
            CGFloat result = one + two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr addObject:unUseModel.ID];
            [self.unCanUse_red_ID_mArr addObject:unUseModel.ID];
            
            if (self.unCanUse_red_ID_mArr.count == 1) {
                self.all_redInvestFullMomey_sum_str = @"";
            }
            CGFloat sum = [unUseModel.investFullMomey floatValue];
            // 新增投资金钱数
            CGFloat oldMoney = [self.currentBidMoneyLabel.text floatValue];
            
            if (oldMoney == [self.all_redInvestFullMomey_sum_str floatValue]) {
                
                self.newAddMoney = sum;
                NSString *tempStr = [NSString stringWithFormat:@"需要新增%.f元", self.newAddMoney];
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:tempStr delayTime:1.0];
                self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", sum + oldMoney];
            } else {
                CGFloat newAddMoney = sum - oldMoney;
                self.newAddMoney = newAddMoney;
                NSString *tempStr = [NSString stringWithFormat:@"需要新增%.f元", newAddMoney];
                if (sum != oldMoney) {
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:tempStr delayTime:1.0];
                }
                self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", sum];
            }
            
            self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%@元", self.all_redInvestFullMomey_sum_str];

        } else {
            
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [unUseModel.money floatValue];
            CGFloat result = one + two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr addObject:unUseModel.ID];
            [self.unCanUse_red_ID_mArr addObject:unUseModel.ID];

            
            CGFloat sum = [unUseModel.investFullMomey floatValue];
            // 新增投资金钱数
            CGFloat oldMoney = [self.currentBidMoneyLabel.text floatValue];
            
            if (oldMoney == [self.all_redInvestFullMomey_sum_str floatValue]) {
                
                self.newAddMoney = sum;
                NSString *tempStr = [NSString stringWithFormat:@"需要新增%.f元", self.newAddMoney];
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:tempStr delayTime:1.0];
                self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", sum + oldMoney];
            } else {
                SGDebugLog(@"all_redInvestFullMomey_sum_str - - %@", self.all_redInvestFullMomey_sum_str);
                CGFloat newMoney = sum + [self.all_redInvestFullMomey_sum_str floatValue];
                self.newAddMoney = newMoney - oldMoney;
                NSString *tempStr = [NSString stringWithFormat:@"需要新增%.f元", _newAddMoney];
                if (sum != oldMoney) {
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:tempStr delayTime:1.0];
                }
                self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", newMoney];
            }
            
            self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%@元", self.all_redInvestFullMomey_sum_str];
        }

    } else {

        if (self.canUse_red_ID_mArr.count == 0) { // 没有最优红包数
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [unUseModel.money floatValue];
            CGFloat result = one - two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr removeObject:unUseModel.ID];
            [self.unCanUse_red_ID_mArr removeObject:unUseModel.ID];
            
            CGFloat downOne = [self.all_redInvestFullMomey_sum_str floatValue];
            // 新增投资金钱数
            CGFloat lastMoney = downOne - [unUseModel.investFullMomey floatValue];
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", lastMoney];
            if (lastMoney == [self.bidMoneyStr floatValue]) {
                self.all_redInvestFullMomey_sum_str = self.first_redInvestFullMomey_sum_str;
            }
            
            if ([self.all_redInvestFullMomey_sum_str floatValue] < [self.bidMoneyStr floatValue]) {
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.bidMoneyStr floatValue]];
            } else {
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.all_redInvestFullMomey_sum_str floatValue]];
            }
            
        } else {
            
            CGFloat one = [_sportMoney floatValue];
            CGFloat two = [unUseModel.money floatValue];
            CGFloat result = one - two;
            self.chioseRedMoneyLabel.text = [NSString stringWithFormat:@"%ld元", (long)result];
            self.sportMoney = self.chioseRedMoneyLabel.text;
            [self.all_red_ID_mArr removeObject:unUseModel.ID];
            [self.unCanUse_red_ID_mArr removeObject:unUseModel.ID];
            
            CGFloat downOne = [self.all_redInvestFullMomey_sum_str floatValue];
            // 新增投资金钱数
            CGFloat lastMoney = downOne - [unUseModel.investFullMomey floatValue];
            self.all_redInvestFullMomey_sum_str = [NSString stringWithFormat:@"%.f", lastMoney];
            if (lastMoney == [self.bidMoneyStr floatValue]) {
                self.all_redInvestFullMomey_sum_str = self.first_redInvestFullMomey_sum_str;
            }
            
            if ([self.all_redInvestFullMomey_sum_str floatValue] < [self.bidMoneyStr floatValue]) {
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.bidMoneyStr floatValue]];
            } else {
                self.currentBidMoneyLabel.text = [NSString stringWithFormat:@"%.f元", [self.all_redInvestFullMomey_sum_str floatValue]];
            }
        }
    }

}

#pragma mark - - - 确定按钮的点击事件
- (IBAction)sureButton_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    self.valueStr(self.chioseRedMoneyLabel.text);
    NSString *string = [self.all_red_ID_mArr componentsJoinedByString:@","];
    self.valueArr(string);
    
    if ([self.all_redInvestFullMomey_sum_str floatValue] <= [self.bidMoneyStr floatValue]) {
        self.newMoney(self.bidMoneyStr);
    } else {
        self.newMoney(self.all_redInvestFullMomey_sum_str);
    }
}


/*
 
 NSNumber *sum = [testArrayvalueForKeyPath:@"@sum.floatValue"];
 
 NSNumber *avg= [testArray valueForKeyPath:@"@avg.floatValue"];
 
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
