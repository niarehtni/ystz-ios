//
//  JCBInvestmentSummaryVC.m
//  JCBJCB
//
//  Created by apple on 17/1/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBInvestmentSummaryVC.h"
#import "JCBInvestmentSummaryTVC.h"
#import "JCBInvestmentSummary.h"
#import "JCBInvestmentSummaryTopTVC.h"
#import "JCBInvestmentSummaryBottomTVC.h"

@interface JCBInvestmentSummaryVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *leftTitle_arr;
@property (nonatomic, strong) NSArray *rightTitle_arr;
@property (nonatomic, copy) NSString *repaymentStatus;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *hongbaoAmount;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *timeLimit;
@property (nonatomic, copy) NSString *years_Apr;
@property (nonatomic, copy) NSString *bidding_time;
@property (nonatomic, strong) NSArray *dataSource_arr;
@end

@implementation JCBInvestmentSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投资概括";
    self.view.backgroundColor = SGCommonBgColor;
    self.leftTitle_arr = @[@"投标时间", @"投资金额 (元)", @"红包支付 (元)", @"项目收益 (元)", @"项目期限 (天)", @"年化收益 (％)", @"回款至"];
    self.dataSource_arr = [NSArray array];
    
    [self foundTableView];
    
    [self getDataFromNetWorking];
    
}

- (void)getDataFromNetWorking {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenterBorrowRepList", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.bid_id;

    [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
        SGDebugLog(@"dictionary - - - %@", dictionary);
        self.repaymentStatus = dictionary[@"borrowStatusVal"];
        self.account = dictionary[@"account"];
        if ([dictionary[@"hongbaoAmount"] integerValue] == 0) {
            self.hongbaoAmount = @"0.00";
        } else {
            self.hongbaoAmount = dictionary[@"hongbaoAmount"];
        }
        self.interest = dictionary[@"interest"];
        self.timeLimit = dictionary[@"timeLimit"];
        self.years_Apr = dictionary[@"apr"];
        self.bidding_time = dictionary[@"createTime"];
        self.dataSource_arr = [JCBInvestmentSummary mj_objectArrayWithKeyValuesArray:dictionary[@"userRepDetailList"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
}

- (void)foundTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBInvestmentSummaryTVC class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBInvestmentSummaryTopTVC class]) bundle:nil] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBInvestmentSummaryBottomTVC class]) bundle:nil] forCellReuseIdentifier:@"bottomCell"];

}


#pragma mark - - - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else if (section == 1) {
        return 1;
    } else {
        return self.dataSource_arr.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JCBInvestmentSummaryTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.left_title.text = self.leftTitle_arr[indexPath.row];
        if (indexPath.row == 0) {
            cell.right_label.text = self.bidding_time;
        } else if (indexPath.row == 1) {
            cell.right_label.text = self.account;
        } else if (indexPath.row == 2) {
            cell.right_label.text = self.hongbaoAmount;
        } else if (indexPath.row == 3) {
            cell.right_label.text = self.interest;
        } else if (indexPath.row == 4) {
            cell.right_label.text = self.timeLimit;
        } else if (indexPath.row == 5) {
            cell.right_label.text = [NSString stringWithFormat:@"%.2f", [self.years_Apr floatValue]];
        } else {
            cell.right_label.text = @"账户余额";
        }
        return cell;
    } else if (indexPath.section == 1) {
        JCBInvestmentSummaryTopTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        JCBInvestmentSummaryBottomTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JCBInvestmentSummary *model = self.dataSource_arr[indexPath.row];
        cell.model = model;
        return cell;
    }
        
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
    CGFloat labelH = 5 * SGMargin;

    if (section == 0) {
        view.backgroundColor = SGColorWithWhite;
        
        UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat right_buttonW = 60;
        CGFloat right_buttonH = 3 * SGMargin;
        CGFloat right_buttonX = SG_screenWidth - right_buttonW - SGMargin;
        CGFloat right_buttonY = SGMargin;
        right_button.frame = CGRectMake(right_buttonX, right_buttonY, right_buttonW, right_buttonH);
        //right_button.backgroundColor = SGColorWithRandom;
        [right_button setTitle:self.repaymentStatus forState:(UIControlStateNormal)];
        if ([self.repaymentStatus isEqualToString:@"还款中"]) {
            [right_button setImage:[UIImage imageNamed:@"mine_investmentSummary_icon"] forState:(UIControlStateNormal)];
            [right_button setImage:[UIImage imageNamed:@"mine_investmentSummary_icon"] forState:(UIControlStateHighlighted)];
        } else {
            [right_button setImage:[UIImage imageNamed:@"mine_investmentSummary_end_icon"] forState:(UIControlStateNormal)];
            [right_button setImage:[UIImage imageNamed:@"mine_investmentSummary_end_icon"] forState:(UIControlStateHighlighted)];
        }
        [right_button setTitleColor:SGColorWithDarkGrey forState:(UIControlStateNormal)];
        right_button.titleEdgeInsets = UIEdgeInsetsMake(0, SGMargin, 0, 0);
        right_button.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
        [view addSubview:right_button];
        

        UILabel *left_label = [[UILabel alloc] init];
        left_label.frame = CGRectMake(SGMargin, 0, SG_screenWidth - 2 * SGMargin - right_buttonW, labelH);
        left_label.text = self.investment_title;
        left_label.textColor = [UIColor blackColor];
        left_label.font = [UIFont boldSystemFontOfSize:17];
        //left_label.backgroundColor = SGColorWithRandom;
        [view addSubview:left_label];
        return view;
    } else if (section == 1) {
        view.backgroundColor = SGColorWithClear;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(SGMargin, 0, 100, 3 * SGMargin);
        label.text = @"还款计划";
        label.font = [UIFont systemFontOfSize:SGTextFontWith16];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5 * SGMargin;
    } else if (section == 1) {
        return 3 * SGMargin;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 47;
    } else {
        return 44;
    }
}


@end

