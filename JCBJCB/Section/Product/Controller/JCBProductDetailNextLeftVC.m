//
//  JCBProductDetailNextLeftVC.m
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailNextLeftVC.h"
#import "JCBProductDNLeftTVCell.h"
#import "JCBProductDNLeftTVTwoCell.h"
#import "JCBProductDNLeftTVThreeCell.h"
#import "JCBProductDNLeftTVFourCell.h"
#import "JCBProjectDescriptionModel.h"

#define textFont [UIFont systemFontOfSize:14.0]

@interface JCBProductDetailNextLeftVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *dataSourse_dic;
@property (strong, nonatomic) NSArray *dataSource_arr;
@property (copy, nonatomic) NSString *dataSource_str; // 记录总钱数
@property (copy, nonatomic) NSString *dataSource_str2; // 记录总收益

@end

@implementation JCBProductDetailNextLeftVC

static CGFloat const sectionHeaderHeight = 40;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SGCommonBgColor;
    
    [self foundTableView];
    
    [self getDataFromNetWorking];
}

- (void)foundTableView {
    self.tableView = [[JCBTableView alloc] initWithFrame:CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - navigationAndStatusBarHeight - cellDeautifulHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 添加这两行代码
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // 注册
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDNLeftTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDNLeftTVTwoCell class]) bundle:nil] forCellReuseIdentifier:@"twoCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDNLeftTVThreeCell class]) bundle:nil] forCellReuseIdentifier:@"threeCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBProductDNLeftTVFourCell class]) bundle:nil] forCellReuseIdentifier:@"fourCell"];
    [self.view addSubview:_tableView];
}

- (void)getDataFromNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/repaymentInfo/%@", SGCommonURL, self.idStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"repaymentInfo - json - - - %@", json);
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        self.dataSourse_dic = json;
        self.dataSource_arr = [JCBProjectDescriptionModel mj_objectArrayWithKeyValuesArray:json[@"repaymentDetailList"]];
        self.dataSource_str = json[@"account"];
        self.dataSource_str2 = json[@"interest"];

        SGDebugLog(@"dataSource_arr - - %@", self.dataSource_arr);
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        SGDebugLog(@"%@", error);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 4) {
        UIView *view = [[UIView alloc] init];

        UILabel *label = [[UILabel alloc] init];
        label.font = textFont;
        label.textColor = SGColorWithDarkGrey;
        if (section == 0) {
            label.text = @"   债务人信息";
        } else if (section == 1) {
            label.text = @"项目描述";

        } else if (section == 2) {
            label.text = @"资金用途";

        } else if (section == 3) {
            label.text = @"还款来源";

        } else {
            label.text = @"还款计划";
        }
        if (section == 0) {
            label.frame = CGRectMake(0, SGMargin, SG_screenWidth, sectionHeaderHeight);
            view.backgroundColor = SGCommonBgColor;
            label.backgroundColor = SGColorWithWhite;
        } else {
            label.frame = CGRectMake(SGMargin, 0, 200, sectionHeaderHeight);
            view.backgroundColor = SGColorWithWhite;
        }
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return sectionHeaderHeight + SGMargin;
    } else if (section == 1 || section == 2 || section == 3 || section == 4) {
        return sectionHeaderHeight;
    } else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 4) {
        return 1;
    } else if (section == 5) {
        return self.dataSource_arr.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JCBProductDNLeftTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.content_label.text = self.dataSourse_dic[@"debtMess"];
        return cell;
    } else if (indexPath.section == 1){
        JCBProductDNLeftTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.content_label.text = self.dataSourse_dic[@"content"];
        return cell;
    } else if (indexPath.section == 2) {
        JCBProductDNLeftTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.content_label.text = self.dataSourse_dic[@"useReason"];
        return cell;

    } else if (indexPath.section == 3) {
        JCBProductDNLeftTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.content_label.text = self.dataSourse_dic[@"paymentSource"];
        return cell;

    } else if (indexPath.section == 4) {
        JCBProductDNLeftTVTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (indexPath.section == 5) {
        JCBProductDNLeftTVThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JCBProjectDescriptionModel *model = self.dataSource_arr[indexPath.row];
        cell.model = model;
        return cell;
    } else {
        JCBProductDNLeftTVFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.allAccount_label.text = [NSString stringWithFormat:@"%.f", [self.dataSource_str floatValue]]; // 还款总额
        CGFloat lastStr = [self.dataSource_str floatValue] - [self.dataSource_str2 floatValue];
        cell.allCapital_label.text = [NSString stringWithFormat:@"%.f", lastStr]; // 还款本息
        cell.allInterest_label.text = self.dataSource_str2; // 还款利息

        return cell;
    }

}


@end
