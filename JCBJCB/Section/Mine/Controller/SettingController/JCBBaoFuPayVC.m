//
//  JCBBaoFuPayVC.m
//  JCBJCB
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCBBaoFuPayVC.h"
#import <BaoFooPay/BaoFooPay.h>

@interface JCBBaoFuPayVC () <BaofooSdkDelegate, SGAlertViewDelegate>

@end

@implementation JCBBaoFuPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"宝付认证支付";
    
    self.view.backgroundColor = SGCommonBgColor;
    
    [self getDataSourceFromNetWorking];
}

- (void)getDataSourceFromNetWorking {
    NSString *urlStr = self.baoFu_dict[@"postUrl"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"back_url"] = self.baoFuModel.back_url;
    params[@"data_content"] = self.baoFuModel.data_content;
    params[@"data_type"] = self.baoFuModel.data_type;
    params[@"input_charset"] = self.baoFuModel.input_charset;
    params[@"language"] = self.baoFuModel.language;
    params[@"member_id"] = self.baoFuModel.member_id;
    params[@"terminal_id"] = self.baoFuModel.terminal_id;
    params[@"txn_sub_type"] = self.baoFuModel.txn_sub_type;
    params[@"txn_type"] = self.baoFuModel.txn_type;
    params[@"version"] = self.baoFuModel.version;

    [SGHttpTool postAll:urlStr params:params success:^(id json) {
        
        SGDebugLog(@"json json - - - %@", json);
        
        if ([json[@"retCode"] isEqualToString:@"0000"]) {
            BaoFooPayController *baoFuPayC_web = [[BaoFooPayController alloc] init];
            baoFuPayC_web.PAY_TOKEN = json[@"tradeNo"];
            baoFuPayC_web.delegate = self;
            baoFuPayC_web.PAY_BUSINESS = @"true";
            
            [self presentViewController:baoFuPayC_web animated:YES completion:^{}];

        } else if ([json[@"retCode"] isEqualToString:@"0001"]) {
            SGAlertView *alertV = [SGAlertView alertViewWithTitle:nil delegate:nil contentTitle:@"交易失败；详情请咨询宝付" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
            [alertV show];
        }
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);

    }];
    
}

#pragma mark - - - BaofooDelegate
-(void)callBack:(NSString *)params {
    SGDebugLog(@"params - - - %@",params);
    
    if ([params isEqualToString:@"0,订单取消"]) {
        

    } else {
        SGAlertView *alertV = [SGAlertView alertViewWithTitle:@"温馨提示" delegate:self contentTitle:[NSString stringWithFormat:@"支付结果:%@",params] alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alertV show];
    }

}

#pragma mark - - - SGAlertViewDelegate
- (void)didSelectedRightButtonClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
