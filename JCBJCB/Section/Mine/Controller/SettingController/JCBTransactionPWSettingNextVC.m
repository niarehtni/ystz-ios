//
//  JCBTransactionPWSettingNextVC.m
//  JCBJCB
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBTransactionPWSettingNextVC.h"
#import "STCountDownButton.h"

@interface JCBTransactionPWSettingNextVC ()
@property (weak, nonatomic) IBOutlet UITextField *oneTF;
@property (weak, nonatomic) IBOutlet UITextField *twoTF;
@property (weak, nonatomic) IBOutlet UITextField *threeTF;
@property (weak, nonatomic) IBOutlet UIButton *ressting_transaction_PW_btn;
@property (weak, nonatomic) IBOutlet STCountDownButton *get_VCode_btn;

@property (nonatomic, strong) NSDictionary *dataSource_dict;

@end

@implementation JCBTransactionPWSettingNextVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        self.dataSource_dict = json;
        SGDebugLog(@"json - - - %@", json);
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"重置交易密码";
    self.view.backgroundColor = SGCommonBgColor;
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(fingerTapped:)];
    // 设置子控件
    [self setupSubviews];
    
    [self.get_VCode_btn setSecond:registerCountDownTime];
}

- (void)setupSubviews {
    self.oneTF.tintColor = SGColorWithRed;
    self.twoTF.tintColor = SGColorWithRed;
    self.threeTF.tintColor = SGColorWithRed;
    self.ressting_transaction_PW_btn.backgroundColor = SGCommonRedColor;
    [SGSmallTool SG_smallWithThisView:self.oneTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.twoTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.threeTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.get_VCode_btn cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.ressting_transaction_PW_btn cornerRadius:5];
}

#pragma mark - - - 手势点击事件
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

#pragma mark - - - 获取验证码点击事件
- (IBAction)get_VCode_btn_action:(id)sender {
    
    if (self.oneTF.text.length == 0) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"身份证后8位不能为空" delayTime:0.5];
    } else  {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/sendPCodeb", SGCommonURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phoneReg"] = self.dataSource_dict[@"username"];
        [SGHttpTool postAll:urlStr params:params success:^(id json) {
            if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"短信发送成功, 请稍等..." delayTime:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.get_VCode_btn start];
                });
            }
            SGDebugLog(@"json - - - %@", json);
        } failure:^(NSError *error) {
            SGDebugLog(@"error - - - %@", error);
        }];
    }
}

#pragma mark - - - 重置交易密码点击事件
- (IBAction)ressting_transaction_PW_btn_action:(id)sender {
    if (self.oneTF.text.length == 0) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"身份证后8位不能为空" delayTime:0.5];
    } else {
        if (self.twoTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"短信验证码不能为空" delayTime:0.5];
        } else {
            if (self.threeTF.text.length == 0) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"新的交易密码不能为空" delayTime:0.5];
            } else if (self.threeTF.text.length < 6 || self.threeTF.text.length > 16) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"新密码字符长度6-16之间" delayTime:0.5];
            } else {
                [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在提交数据，请稍等" toView:self.navigationController.view];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userSafePasswordUpdate", SGCommonURL];
                urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                // 参数
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"cardId"] = self.oneTF.text;
                params[@"codeReq"] = self.twoTF.text;
                params[@"newPassword"] = self.threeTF.text;

                [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    SGDebugLog(@"dictionary - userSafePasswordUpdate - - - %@", dictionary);
                    if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) {
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"设置成功" delayTime:1.0];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    } else {
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:dictionary[@"rmg"] delayTime:1.0];
                    }
                } failure:^(NSError *error) {
                    SGDebugLog(@"error - - - %@", error);
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    
                }];
            }
        }

    }
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
