//
//  JCBLoginVC.m
//  JCBJCB
//
//  Created by Sorgle on 2016/10/19.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBLoginVC.h"
#import "JCBForgetPasswordVC.h"
#import "AppDelegate.h"
#import "JCBTabBarController.h"


NSString * const kLoginVC = @"loginVC";

@interface JCBLoginVC () <UITextFieldDelegate>
@property (nonatomic, strong) SGTextField *phoneNum_TF;
@property (nonatomic, strong) SGTextField *password_TF;
@end

@implementation JCBLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 点击空白处回收键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [SGNotificationCenter addObserver:self selector:@selector(textFieldKeyBoard) name:kLoginVC object:nil];
    // 创建子视图
    [self setupSubviews];
}

- (void)textFieldKeyBoard {
    [self.view endEditing:YES];
}

// 创建子视图
- (void)setupSubviews {
    CGFloat iphone4s_height = SGLoginRegisterBGViewWithIphone4sHeight;
    CGFloat iphone5s_height = SGLoginRegisterBGViewWithIphone5sHeight;
    CGFloat iphone6s_height = SGLoginRegisterBGViewWithIphone6sHeight;
    CGFloat iphone6p_height = SGLoginRegisterBGViewWithIphone6PHeight;

    // 手机输入框背景视图
    UIView *oneView = [[UIView alloc] init];
    CGFloat oneViewX = 0;
    CGFloat oneViewY = 30;
    CGFloat oneViewW = SG_screenWidth;
    CGFloat oneViewH = 0;
    if (iphone5s) {
        oneViewH = iphone5s_height;
    } else if (iphone6s) {
        oneViewH = iphone6s_height;
    } else if (iphone6P) {
        oneViewH = iphone6p_height;
    } else if (iphone4s) {
        oneViewH = iphone4s_height;
    }
    oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
//    oneView.backgroundColor = [UIColor redColor];
    [self.view addSubview:oneView];
    
    // 小图标
    UIImageView *PN_imageView = [[UIImageView alloc] init];
    PN_imageView.image = [UIImage imageNamed:@"login_register_phoneNumber"];
    CGFloat PN_imageViewX = 10;
    CGFloat PN_imageViewY = 0;
    CGFloat PN_imageViewH = oneView.SG_height;
    CGFloat PN_imageViewW = PN_imageViewH * PN_imageView.image.size.width / PN_imageView.image.size.height - 0.5 * SGSmallMargin;
    PN_imageView.frame = CGRectMake(PN_imageViewX, PN_imageViewY, PN_imageViewW, PN_imageViewH);
    [oneView addSubview:PN_imageView];
    // 分割线
    UIView *PN_TF_bottom_line = [[UIView alloc] init];
    CGFloat PN_TF_bottom_lineH = 1;
    CGFloat PN_TF_bottom_lineX = loginRegisterMarginSplitLineX;
    CGFloat PN_TF_bottom_lineY = oneViewH - PN_TF_bottom_lineH;
    CGFloat PN_TF_bottom_lineW = SG_screenWidth - PN_TF_bottom_lineX - SGMargin - SGSmallMargin;
    PN_TF_bottom_line.frame = CGRectMake(PN_TF_bottom_lineX, PN_TF_bottom_lineY, PN_TF_bottom_lineW, PN_TF_bottom_lineH);
    PN_TF_bottom_line.backgroundColor = SGSplitLineColor;
    [oneView addSubview:PN_TF_bottom_line];
    // 输入框
    self.phoneNum_TF = [[SGTextField alloc] init];
    CGFloat phoneNum_TFX = PN_TF_bottom_lineX;
    CGFloat phoneNum_TFY = 0;
    CGFloat phoneNum_TFW = PN_TF_bottom_lineW;
    CGFloat phoneNum_TFH = oneViewH - PN_TF_bottom_lineH;
    _phoneNum_TF.frame = CGRectMake(phoneNum_TFX, phoneNum_TFY, phoneNum_TFW, phoneNum_TFH);
    _phoneNum_TF.placeholder = @" 请输入手机号码";
    _phoneNum_TF.tintColor = [UIColor redColor];
    _phoneNum_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNum_TF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum_TF.delegate = self;
    [oneView addSubview:_phoneNum_TF];
//    _phoneNum_TF.backgroundColor = [UIColor yellowColor];
    
    // 密码输入框背景视图
    UIView *twoView = [[UIView alloc] init];
    CGFloat twoViewX = 0;
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + 2 * SGMargin;
    CGFloat twoViewW = SG_screenWidth;
    CGFloat twoViewH = oneViewH;
    twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
//    twoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:twoView];
    
    // 小图标
    UIImageView *PW_imageView = [[UIImageView alloc] init];
    PW_imageView.image = [UIImage imageNamed:@"login_register_password"];
    CGFloat PW_imageViewX = 10;
    CGFloat PW_imageViewY = 0;
    CGFloat PW_imageViewH = twoView.SG_height;
    CGFloat PW_imageViewW = PW_imageViewH * PW_imageView.image.size.width / PW_imageView.image.size.height - 0.5 * SGSmallMargin;
    PW_imageView.frame = CGRectMake(PW_imageViewX, PW_imageViewY, PW_imageViewW, PW_imageViewH);
    [twoView addSubview:PW_imageView];
    // 分割线
    UIView *PW_TF_bottom_line = [[UIView alloc] init];
    CGFloat PW_TF_bottom_lineH = 1;
    CGFloat PW_TF_bottom_lineX = loginRegisterMarginSplitLineX;
    CGFloat PW_TF_bottom_lineY = twoViewH - PW_TF_bottom_lineH;
    CGFloat PW_TF_bottom_lineW = SG_screenWidth - PW_TF_bottom_lineX - SGMargin - SGSmallMargin;
    PW_TF_bottom_line.frame = CGRectMake(PW_TF_bottom_lineX, PW_TF_bottom_lineY, PW_TF_bottom_lineW, PW_TF_bottom_lineH);
    PW_TF_bottom_line.backgroundColor = SGSplitLineColor;
    [twoView addSubview:PW_TF_bottom_line];
    // 输入框
    self.password_TF = [[SGTextField alloc] init];
    CGFloat password_TFX = PN_TF_bottom_lineX;
    CGFloat password_TFY = 0;
    CGFloat password_TFW = PN_TF_bottom_lineW;
    CGFloat password_TFH = oneViewH - PN_TF_bottom_lineH;
    _password_TF.frame = CGRectMake(password_TFX, password_TFY, password_TFW, password_TFH);
    _password_TF.placeholder = @" 请输入登录密码";
    _password_TF.tintColor = [UIColor redColor];
    _password_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password_TF.delegate = self;
    _password_TF.secureTextEntry = YES;
    [twoView addSubview:_password_TF];
    
    
    // 忘记密码按钮
    UIButton *forget_pw = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat forget_pwW = 100;
    CGFloat forget_pwH = 30;
    CGFloat forget_pwX = (SG_screenWidth - forget_pwW);
    CGFloat forget_pwY = CGRectGetMaxY(twoView.frame) + SGMargin;
    forget_pw.frame = CGRectMake(forget_pwX, forget_pwY, forget_pwW, forget_pwH);
    [forget_pw setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
    forget_pw.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    [forget_pw setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [forget_pw addTarget:self action:@selector(forget_password_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:forget_pw];
    
    // 登录按钮
    UIButton *login_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat login_btnX = SGMargin;
    CGFloat login_btnY = CGRectGetMaxY(forget_pw.frame) + 2 * SGMargin;
    CGFloat login_btnW = SG_screenWidth - 2 * login_btnX;
    CGFloat login_btnH = 0;
    if (iphone5s) {
        login_btnH = SGLoginBtnWithIphone5sHeight;
    } else if (iphone6s) {
        login_btnH = SGLoginBtnWithIphone6sHeight;
    } else if (iphone6P) {
        login_btnH = SGLoginBtnWithIphone6PHeight;
    } else if (iphone4s) {
        login_btnH = SGLoginBtnWithIphone4sHeight;
    }
    
    login_btn.frame = CGRectMake(login_btnX, login_btnY, login_btnW, login_btnH);
    [login_btn setTitle:@"登录" forState:(UIControlStateNormal)];
    login_btn.backgroundColor = SGCommonRedColor;
    login_btn.layer.cornerRadius = 5;
    login_btn.layer.masksToBounds = YES;
    [login_btn addTarget:self action:@selector(login_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:login_btn];
    
#pragma mark - - - 统一设置SGPlaceholderLabel字体的大小
    if (iphone5s) {
        CGFloat labelFont5s = SGLoginRegisterBtnWithIphone5sPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone6s) {
        CGFloat labelFont6s = SGLoginRegisterBtnWithIphone6sPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone6P) {
        CGFloat labelFont6P = SGLoginRegisterBtnWithIphone6PPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone4s) {
        CGFloat labelFont4s = SGLoginRegisterBtnWithIphone4sPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont4s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont4s] forKeyPath:SGPlaceholderLabelFontKey];

    }
}
#pragma mark - - - 忘记密码按钮点击事件
- (void)forget_password_action:(UIButton *)button {
    if (iphone5s) {
        self.view.transform = CGAffineTransformIdentity;
    }
    SGDebugLog(@"忘记密码?");
    JCBForgetPasswordVC *forgetPWVC = [[JCBForgetPasswordVC alloc] init];
    forgetPWVC.fromeVC = 1;
    [self.navigationController pushViewController:forgetPWVC animated:YES];
}

#pragma mark - - - 登录按钮点击事件
- (void)login_btn_action:(UIButton *)button {
    [self.phoneNum_TF endEditing:YES];
    [self.password_TF endEditing:YES];
    if (iphone5s) {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    SGDebugLog(@"登录");
    if (self.phoneNum_TF.text.length == 0) { // 手机号为空提示
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"手机号码不能为空" delayTime:0.5];
    } else if ([self.phoneNum_TF.text SG_isPhoneNumber]) { // 手机号正确
        if (self.password_TF.text.length == 0) { // 进行密码判断（密码为空提示）
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"密码不能为空" delayTime:0.5];
        } else { // 手机号码、密码正确同时正确
            [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"登录中..." toView:self.navigationController.view];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/rest/login", SGCommonURL];
            
            NSString *userDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:userDeviceToken_key];
            // 立即同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (userDeviceToken == nil) {
                userDeviceToken = @"";
            } else {
                SGDebugLog(@"strToken = %@",userDeviceToken);
            }
            
            // 参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"username"] = self.phoneNum_TF.text;
            params[@"password"] = self.password_TF.text;
            params[@"deviceToken"] = userDeviceToken;

            [SGHttpTool postAll:urlStr params:params success:^(id json) {
                SGDebugLog(@"json - - %@", json);
                if ([json[@"rcd"] isEqualToString:@"M0001"]) { // 手机号和密码不匹配
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的手机号和密码" delayTime:1.0];
                    });

                } else if ([json[@"rcd"] isEqualToString:@"M0004"]) { // 若连续10次密码输入错误, 您的账号将被锁定
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlySmallMessage:@"连续10次密码输入有误, 账号将被锁定" delayTime:1.5];
                    });
                } else if ([json[@"rcd"] isEqualToString:@"M0003"]) { // 账号已被锁定
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"您的账号已被锁定，请联系客服" delayTime:2.0];
                        UIAlertController *alertC = [UIAlertController SG_alertControllerWithTitle:@"提示" message:@"您的账号已被锁定，请联系客服" sureBtn:@"联系客服" cancelBtn:@"取消" preferredStyle:(UIAlertControllerStyleAlert) sureBtnAction:^{
                            
                            UIWebView *phoneNum = [[UIWebView alloc] init];
                            phoneNum.frame = CGRectZero;
                            NSURL *url = [NSURL URLWithString:@"tel://4000577820"];
                            [phoneNum loadRequest:[NSURLRequest requestWithURL:url]];
                            [self.view addSubview:phoneNum];
                            
                        } cancelBtnAction:^{
                            
                        }];
                       
                        [self presentViewController:alertC animated:YES completion:nil];
                    });
                } else if ([json[@"rcd"] isEqualToString:@"R0001"]) { // 登录成功要做一些操作
                    // 1. 存储用户 id 以及 accessToken
                    [SGUserDefaults setObject:json[@"userId"] forKey:userId];
                    [SGUserDefaults setObject:json[@"token"] forKey:userAccessToken];
                    [SGUserDefaults setObject:nil forKey:signIn];
                    // 立即同步
                    [SGUserDefaults synchronize];
                    
                    [AppDelegate configJpushTag];
                    
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    SGDebugLog(@"登录成功");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //[SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"恭喜您登录成功" delayTime:1.0];
                        [self dismissViewControllerAnimated:YES completion:^{
                        }];
                        if ([JCBSingletonManager sharedSingletonManager].isProductDetailLogin == YES) { // 判断登录界面是否从产品详情页过来的
                            
                        } else {
                            if ([JCBSingletonManager sharedSingletonManager].isReviseGesturePWVCToLoginRegister == YES) {
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVCToLoginRegister = NO;
                                }];
                            } else if ([JCBSingletonManager sharedSingletonManager].isUnlockGesturePWVCToLoginRegister == YES) {
                                // 2. 进行界面的跳转
                                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
                                appDelegate.window.rootViewController = tabBarC;
                                //tabBarC.selectedIndex = 0;
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [JCBSingletonManager sharedSingletonManager].isUnlockGesturePWVCToLoginRegister = NO;
                                }];
                            } else {
                                // 2. 进行界面的跳转
                                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
                                appDelegate.window.rootViewController = tabBarC;
                                tabBarC.selectedIndex = 0;
                            }
                        }

                    });
                }
                
            } failure:^(NSError *error) {
                SGDebugLog(@"error - - %@", error);
                [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"登录失败" toView:self.navigationController.view];
                });
            }];
        }
        
    } else { // 手机号不正确提示

        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的手机号码格式" delayTime:1];
    }

}

#pragma mark - - - UITextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SGDebugLog(@" - - - - ");
    if (textField == self.phoneNum_TF) {
        if (iphone5s || iphone4s) {
            self.view.transform = CGAffineTransformIdentity;
        }
    }
    if (iphone5s || iphone4s) {
        if (textField == self.password_TF) {
            self.view.transform = CGAffineTransformMakeTranslation(0, - 15);
        }
    }
    return YES;
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    
    if (iphone5s || iphone4s) {
        self.view.transform = CGAffineTransformIdentity;
    }
}

- (void)dealloc {
    SGDebugLog(@"JCBLoginVC - - dealloc");
    [SGNotificationCenter removeObserver:self name:kLoginVC object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


