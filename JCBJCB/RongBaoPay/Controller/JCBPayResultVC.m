//
//  JCBPayResultVC.m
//  JCBJCB
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBPayResultVC.h"
#import "JCBRechargeCashVC.h"
#import "JCBImmediateInvestmentVC.h"

@interface JCBPayResultVC ()
@property (weak, nonatomic) IBOutlet UILabel *payResult_label;
@property (weak, nonatomic) IBOutlet UILabel *order_no_label;
@property (weak, nonatomic) IBOutlet UILabel *payMoney_label;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;

@end

@implementation JCBPayResultVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付结果";
    self.view.backgroundColor = SGCommonBgColor;
    
    // 隐藏 leftBarButtonItem 
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.payResult_label.text = self.result_payment;
    [self setupSubviews];
}

- (void)setupSubviews {
    // Dispose of any resources that can be recreated.
    self.sure_btn.backgroundColor = SGCommonRedColor;
    self.order_no_label.text = [NSString stringWithFormat:@"订单号：%@", self.result_order_no];
    self.payMoney_label.text = [NSString stringWithFormat:@"%@元", self.result_money];
    [SGSmallTool SG_smallWithThisView:self.sure_btn cornerRadius:5];
}

- (IBAction)sureBtn_action:(id)sender {
    if ([JCBSingletonManager sharedSingletonManager].isSureInvestment == YES) {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[JCBImmediateInvestmentVC class]]) {
                JCBImmediateInvestmentVC *IIVC = (JCBImmediateInvestmentVC *)VC;
                [self.navigationController popToViewController:IIVC animated:YES];
            }
        }
        [JCBSingletonManager sharedSingletonManager].isSureInvestment = NO;
        [SGNotificationCenter postNotificationName:@"ImmediateInvestmentGetDataSource" object:nil userInfo:nil];
        
    } else { // 首次充值进行的
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[JCBRechargeCashVC class]]) {
                JCBRechargeCashVC *RCVC = (JCBRechargeCashVC *)VC;
                [self.navigationController popToViewController:RCVC animated:YES];
            }
        }
        
        [SGNotificationCenter postNotificationName:@"rechargeGetDataSource" object:nil userInfo:nil];

        [SGNotificationCenter postNotificationName:@"cashGetDataSource" object:nil userInfo:nil];
    }
}

@end
