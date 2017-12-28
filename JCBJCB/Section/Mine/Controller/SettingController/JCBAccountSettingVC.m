//
//  JCBAccountSettingVC.m
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBAccountSettingVC.h"
#import "JCBBingCardAuthenticationVC.h"
#import "JCBAlreadyBingCardAuthenticationVC.h"
#import "JCBLoginPWSettingVC.h"
#import "JCBTransactionPWSettingVC.h"
#import "SGSettingGesturePWVC.h"
#import "SGReviseGesturePWVC.h"

@interface JCBAccountSettingVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataSource_dict;
@end

@implementation JCBAccountSettingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];

    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/user", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"user - json - - - %@", json);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        self.dataSource_dict = json;
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"error - - - %@", error);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账户设置";
    
    [self foundTableView];
}

- (void)foundTableView {
    CGFloat rowHeight;
    if (iphone5s) {
        rowHeight = 50;
    } else if (iphone6s) {
        rowHeight = 56;
    } else if (iphone6P) {
        rowHeight = 62;
    }
    
    self.tableView.backgroundColor = SGCommonBgColor;
    self.tableView.rowHeight = rowHeight;
    // 隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[SGUserDefaults objectForKey:switchState] isEqualToString:@"on"]) {
        return 5;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_setting_bing_card_icon"];
        if ([self.dataSource_dict[@"bankStatus"] intValue] == 0) {
            cell.detailTextLabel.text = @"未认证";
        } else if ([self.dataSource_dict[@"bankStatus"] intValue] == 1) {
            cell.detailTextLabel.text = @"已认证";
        }
        cell.textLabel.text = @"绑卡认证";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:SGTextFontWith16];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    } else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"mine_setting_login_pw_icon"];
        cell.textLabel.text = @"修改登录密码";
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"mine_setting_transaction_pw_icon"];
        cell.textLabel.text = @"修改交易密码";
    } else if (indexPath.row == 3) {
        UISwitch *sh = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sh addTarget:self action:@selector(gesturePasswordSwitch:) forControlEvents:UIControlEventValueChanged];
        if ([[SGUserDefaults objectForKey:switchState] isEqualToString:@"on"]) {
            sh.on = YES;
        } else {
            sh.on = NO;
        }
        cell.accessoryView = sh;
        cell.imageView.image = [UIImage imageNamed:@"mine_setting_gesturepw_icon"];
        cell.textLabel.text = @"手势密码";
    } else {
        cell.imageView.image = [UIImage imageNamed:@"mine_setting_gesturepw_icon"];
        cell.textLabel.text = @"修改手势密码";
    }
    return cell;
}

- (void)gesturePasswordSwitch:(UISwitch *)switchBtn {
    if (switchBtn.on) {
        UIAlertController *alertC = [UIAlertController SG_alertControllerWithTitle:nil message:@"开启后，进入App时需要输入正确的手势密码" preferredStyle:(UIAlertControllerStyleAlert) sureAction:^{
            SGSettingGesturePWVC *settingGPWVC = [[SGSettingGesturePWVC alloc] init];
            [self.navigationController pushViewController:settingGPWVC animated:YES];
            
        } cancelAction:^{
            switchBtn.on = NO;
        }];
        
        [self presentViewController:alertC animated:YES completion:^{
            
        }];

    } else {
        [SGUserDefaults setObject:nil forKey:switchState];
        [SGUserDefaults setObject:nil forKey:gesturePassword];
        [SGUserDefaults synchronize];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
#pragma mark - - - 接入融宝后绑卡界面调整
        if ([self.dataSource_dict[@"bankStatus"]  intValue] == 0) {
            SGAlertView *alertV = [SGAlertView alertViewWithTitle:@"提示" contentTitle:@"完成首次充值后自动绑卡成功" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne) didSelectedBtnIndex:^(SGAlertView *alertView, NSInteger index) {

            }];
            [alertV show];
        } else if ([self.dataSource_dict[@"bankStatus"]  intValue] != 0) {
            JCBAlreadyBingCardAuthenticationVC *alreadyBingCAVC = [[JCBAlreadyBingCardAuthenticationVC alloc] init];
            [self.navigationController pushViewController:alreadyBingCAVC animated:YES];
        }

    } else if (indexPath.row == 1) {
        JCBLoginPWSettingVC *loginPWSVC = [[JCBLoginPWSettingVC alloc] init];
        [self.navigationController pushViewController:loginPWSVC animated:YES];
    } else if (indexPath.row == 2) {
        JCBTransactionPWSettingVC *transactionPWSVC = [[JCBTransactionPWSettingVC alloc] init];
        [self.navigationController pushViewController:transactionPWSVC animated:YES];
    } else if (indexPath.row == 4) {
        SGReviseGesturePWVC *reviseGPWVC = [[SGReviseGesturePWVC alloc] init];
        [self.navigationController pushViewController:reviseGPWVC animated:YES];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SGMargin;
}


@end
