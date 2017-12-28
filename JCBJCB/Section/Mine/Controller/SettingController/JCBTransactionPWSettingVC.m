//
//  JCBTransactionPWSettingVC.m
//  JCBJCB
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBTransactionPWSettingVC.h"
#import "JCBTransactionPWSettingNextVC.h"

@interface JCBTransactionPWSettingVC ()
@property (weak, nonatomic) IBOutlet UITextField *oneTF;
@property (weak, nonatomic) IBOutlet UITextField *twoTF;
@property (weak, nonatomic) IBOutlet UITextField *threeTF;
@property (weak, nonatomic) IBOutlet UIButton *sureModity_btn;

@end

@implementation JCBTransactionPWSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改交易密码";
    self.view.backgroundColor = SGCommonBgColor;
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(fingerTapped:)];


    // 设置子控件
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.oneTF.tintColor = SGColorWithRed;
    self.twoTF.tintColor = SGColorWithRed;
    self.threeTF.tintColor = SGColorWithRed;
    self.sureModity_btn.backgroundColor = SGCommonRedColor;
    
    [SGSmallTool SG_smallWithThisView:self.oneTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.twoTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.threeTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.sureModity_btn cornerRadius:5];
}

#pragma mark - - - 手势点击事件
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}


- (IBAction)forgetPW_btn_action:(id)sender {
    JCBTransactionPWSettingNextVC *nextVC = [[JCBTransactionPWSettingNextVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)sureModity_btn_action:(id)sender {
    if (self.oneTF.text.length == 0) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"原密码不能为空" delayTime:0.5];
    } else {
        if (self.twoTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"新密码不能为空" delayTime:0.5];
        } else if (self.twoTF.text.length < 2 || self.twoTF.text.length > 16) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的密码格式" delayTime:0.5];
        } else {
            if (self.threeTF.text.length == 0) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"再次输入密码不能为空" delayTime:0.5];
            } else {
                if ([self.twoTF.text isEqualToString:self.threeTF.text]) {
                    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在提交数据，请稍等" toView:self.navigationController.view];
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userSafePwdUpdate?oldPassword=%@&newPassword=%@", SGCommonURL, self.oneTF.text, self.twoTF.text];
                    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                    
                    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
                        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

                        if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"恭喜你，修改成功" delayTime:1.0];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            });
                        } else {
                            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", dictionary[@"rmg"]] delayTime:1.0];
                        }
                        SGDebugLog(@"dictionary - - - %@", dictionary);
                    } failure:^(NSError *error) {
                        SGDebugLog(@"error - - - %@", error);
                        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

                    }];
                    
                } else {
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"两次输入密码不一样" delayTime:0.5];
                }
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
