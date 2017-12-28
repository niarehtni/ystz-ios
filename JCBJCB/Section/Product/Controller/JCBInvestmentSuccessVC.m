//
//  JCBInvestmentSuccessVC.m
//  JCBJCB
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBInvestmentSuccessVC.h"
#import "JCBInvestmentRecordVC.h"

@interface JCBInvestmentSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *investmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *continuedInvestmentBtn;

@end

@implementation JCBInvestmentSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投资结果";
    self.view.backgroundColor = SGCommonBgColor;
    
    [self setupSubviews];
}

- (void)setupSubviews {
    [SGSmallTool SG_smallWithThisView:self.investmentBtn cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.continuedInvestmentBtn cornerRadius:5];

    self.projectNameLabel.text = self.projectName;
    self.investmentMoneyLabel.text = [NSString stringWithFormat:@"%@元", self.investmentmoney];
}

/** 投资记录的点击事件 */
- (IBAction)investment_action:(id)sender {
    JCBInvestmentRecordVC *IRVC = [[JCBInvestmentRecordVC alloc] init];
    [self.navigationController pushViewController:IRVC animated:YES];
}

/** 继续投资按钮的点击事件 */
- (IBAction)continuedInvestment_action:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
