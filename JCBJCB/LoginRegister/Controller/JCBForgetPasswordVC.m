//
//  JCBForgetPasswordVC.m
//  JCBJCB
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBForgetPasswordVC.h"
#import "STCountDownButton.h"
#import "AppDelegate.h"
#import "JCBTabBarController.h"
#import "JCBAccountSettingVC.h"

@interface JCBForgetPasswordVC () <UITextFieldDelegate>
@property (nonatomic, strong) SGTextField *phoneNum_TF;
@property (nonatomic, strong) SGTextField *password_TF;
@property (nonatomic, strong) SGTextField *verification_code_TF;
@property (nonatomic, strong) SGTextField *password_again_TF;
@end

@implementation JCBForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重置登录密码";
    self.view.backgroundColor = SGCommonBgColor;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBarButtonItem_action) image:@"navigationButtonReturn" highImage:nil];

    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(fingerTapped:)];

    // 创建子视图
    [self setupSubviews];
    
}


#pragma mark - - - 手势点击事件
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)leftBarButtonItem_action {
    [self.navigationController popViewControllerAnimated:YES];
}

// 创建子视图
- (void)setupSubviews {
    SGDebugLog(@"%@", self.view);
    UIView *bg_view = [[UIView alloc] init];
    [self.view addSubview:bg_view];
    
    CGFloat iphone4s_height = SGLoginRegisterBGViewWithIphone4sHeight;
    CGFloat iphone5s_height = SGLoginRegisterBGViewWithIphone5sHeight;
    CGFloat iphone6s_height = SGLoginRegisterBGViewWithIphone6sHeight;
    CGFloat iphone6p_height = SGLoginRegisterBGViewWithIphone6PHeight;
    
#pragma mark - - - 手机输入框背景视图
    UIView *oneView = [[UIView alloc] init];
    CGFloat oneViewX = 0;
    CGFloat oneViewY = 2 * SGMargin;
    CGFloat oneViewW = SG_screenWidth;
    CGFloat oneViewH;
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
    [bg_view addSubview:oneView];
 
    // 小图标
    UIImageView *PN_imageView = [[UIImageView alloc] init];
    PN_imageView.image = [UIImage imageNamed:@"login_register_phoneNumber"];
    CGFloat PN_imageViewX = SGMargin;
    CGFloat PN_imageViewY = 0;
    CGFloat PN_imageViewH = oneViewH;
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
    _phoneNum_TF.placeholder = @" 请输入认证手机号码";
    _phoneNum_TF.tintColor = [UIColor redColor];
    _phoneNum_TF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [oneView addSubview:_phoneNum_TF];

    
#pragma mark - - - 验证码输入框背景视图
    UIView *twoView = [[UIView alloc] init];
    CGFloat twoViewX = 0;
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + 2 * SGMargin;
    CGFloat twoViewW = SG_screenWidth;
    CGFloat twoViewH = oneViewH;

    twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
    [bg_view addSubview:twoView];
    
    // 小图标
    UIImageView *VC_imageView = [[UIImageView alloc] init];
    VC_imageView.image = [UIImage imageNamed:@"login_register_verificationCode"];
    CGFloat VC_imageViewX = SGMargin;
    CGFloat VC_imageViewY = 0;
    CGFloat VC_imageViewH = twoViewH;
    CGFloat VC_imageViewW = VC_imageViewH * VC_imageView.image.size.width / VC_imageView.image.size.height - 0.5 * SGSmallMargin;
    VC_imageView.frame = CGRectMake(VC_imageViewX, VC_imageViewY, VC_imageViewW, VC_imageViewH);
    [twoView addSubview:VC_imageView];
    
    // 获取验证码按钮
    CGFloat getVC_btnW = 9 * SGMargin;
    CGFloat getVC_btnH = twoViewH;
    CGFloat getVC_btnX = SG_screenWidth - getVC_btnW - SGMargin;
    CGFloat getVC_btnY = 0;
    STCountDownButton *getVC_btn = [[STCountDownButton alloc]initWithFrame:CGRectMake(getVC_btnX, getVC_btnY, getVC_btnW, getVC_btnH)];
    getVC_btn.backgroundColor = SGColorWithRed;
    [SGSmallTool SG_smallWithThisView:getVC_btn cornerRadius:5];
    getVC_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getVC_btn setSecond:registerCountDownTime];
    [getVC_btn addTarget:self action:@selector(startCountDown:)forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:getVC_btn];
    
    // 分割线
    UIView *VC_TF_bottom_line = [[UIView alloc] init];
    CGFloat VC_TF_bottom_lineH = 1;
    CGFloat VC_TF_bottom_lineX = loginRegisterMarginSplitLineX;
    CGFloat VC_TF_bottom_lineY = twoViewH - VC_TF_bottom_lineH;
    CGFloat VC_TF_bottom_lineW = SG_screenWidth - VC_TF_bottom_lineX - SGMargin - SGSmallMargin - getVC_btnW;
    VC_TF_bottom_line.frame = CGRectMake(VC_TF_bottom_lineX, VC_TF_bottom_lineY, VC_TF_bottom_lineW, VC_TF_bottom_lineH);
    VC_TF_bottom_line.backgroundColor = SGSplitLineColor;
    [twoView addSubview:VC_TF_bottom_line];
    // 输入框
    self.verification_code_TF = [[SGTextField alloc] init];
    CGFloat VC_TFX = VC_TF_bottom_lineX;
    CGFloat VC_TFY = 0;
    CGFloat VC_TFW = VC_TF_bottom_lineW;
    CGFloat VC_TFH = twoViewH - PN_TF_bottom_lineH;
    _verification_code_TF.frame = CGRectMake(VC_TFX, VC_TFY, VC_TFW, VC_TFH);
    _verification_code_TF.placeholder = @" 请输入验证码";
    _verification_code_TF.tintColor = SGColorWithRed;
    _verification_code_TF.keyboardType = UIKeyboardTypeNumberPad;
    _verification_code_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [twoView addSubview:_verification_code_TF];
    //    _phoneNum_TF.backgroundColor = [UIColor yellowColor];

#pragma mark - - - 密码输入框背景视图
    UIView *threeView = [[UIView alloc] init];
    CGFloat threeViewX = 0;
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + 2 * SGMargin;
    CGFloat threeViewW = SG_screenWidth;
    CGFloat threeViewH = twoViewH;
    threeView.frame = CGRectMake(threeViewX, threeViewY, threeViewW, threeViewH);
    // threeView.backgroundColor = [UIColor redColor];
    [bg_view addSubview:threeView];
    
    // 小图标
    UIImageView *PW_imageView = [[UIImageView alloc] init];
    PW_imageView.image = [UIImage imageNamed:@"login_register_password"];
    CGFloat PW_imageViewX = SGMargin;
    CGFloat PW_imageViewY = 0;
    CGFloat PW_imageViewH = threeViewH;
    CGFloat PW_imageViewW = PW_imageViewH * PW_imageView.image.size.width / PW_imageView.image.size.height - 0.5 * SGSmallMargin;
    PW_imageView.frame = CGRectMake(PW_imageViewX, PW_imageViewY, PW_imageViewW, PW_imageViewH);
    [threeView addSubview:PW_imageView];
    // 分割线
    UIView *PW_TF_bottom_line = [[UIView alloc] init];
    CGFloat PW_TF_bottom_lineH = 1;
    CGFloat PW_TF_bottom_lineX = loginRegisterMarginSplitLineX;
    CGFloat PW_TF_bottom_lineY = threeViewH - PW_TF_bottom_lineH;
    CGFloat PW_TF_bottom_lineW = SG_screenWidth - PW_TF_bottom_lineX - SGMargin - SGSmallMargin;
    PW_TF_bottom_line.frame = CGRectMake(PW_TF_bottom_lineX, PW_TF_bottom_lineY, PW_TF_bottom_lineW, PW_TF_bottom_lineH);
    PW_TF_bottom_line.backgroundColor = SGSplitLineColor;
    [threeView addSubview:PW_TF_bottom_line];
    // 输入框
    self.password_TF = [[SGTextField alloc] init];
    CGFloat password_TFX = PN_TF_bottom_lineX;
    CGFloat password_TFY = 0;
    CGFloat password_TFW = PN_TF_bottom_lineW;
    CGFloat password_TFH = threeViewH - PN_TF_bottom_lineH;
    _password_TF.frame = CGRectMake(password_TFX, password_TFY, password_TFW, password_TFH);
    _password_TF.placeholder = @" 请输入新密码，长度8～16位，必须包含字母";
    _password_TF.tintColor = SGColorWithRed;
    _password_TF.delegate = self;
    _password_TF.secureTextEntry = YES;
    _password_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password_TF.keyboardType = UIKeyboardTypeDefault;
    [threeView addSubview:_password_TF];
    
    
#pragma mark - - - 再次输入密码框背景视图
    UIView *fourView = [[UIView alloc] init];
    CGFloat fourViewX = 0;
    CGFloat fourViewY = CGRectGetMaxY(threeView.frame) + 2 * SGMargin;
    CGFloat fourViewW = SG_screenWidth;
    CGFloat fourViewH = threeViewH;
    fourView.frame = CGRectMake(fourViewX, fourViewY, fourViewW, fourViewH);
    //    fourView.backgroundColor = [UIColor redColor];
    [bg_view addSubview:fourView];
    
    // 小图标
    UIImageView *PW2_imageView = [[UIImageView alloc] init];
    PW2_imageView.image = [UIImage imageNamed:@"login_register_password"];
    CGFloat PW2_imageViewX = SGMargin;
    CGFloat PW2_imageViewY = 0;
    CGFloat PW2_imageViewH = fourViewH;
    CGFloat PW2_imageViewW = PW2_imageViewH * PW2_imageView.image.size.width / PW2_imageView.image.size.height - 0.5 * SGSmallMargin;
    PW2_imageView.frame = CGRectMake(PW2_imageViewX, PW2_imageViewY, PW2_imageViewW, PW2_imageViewH);
    [fourView addSubview:PW2_imageView];
    // 分割线
    UIView *PW2_TF_bottom_line = [[UIView alloc] init];
    CGFloat PW2_TF_bottom_lineH = 1;
    CGFloat PW2_TF_bottom_lineX = loginRegisterMarginSplitLineX;
    CGFloat PW2_TF_bottom_lineY = fourViewH - PW2_TF_bottom_lineH;
    CGFloat PW2_TF_bottom_lineW = SG_screenWidth - PW2_TF_bottom_lineX - SGMargin - SGSmallMargin;
    PW2_TF_bottom_line.frame = CGRectMake(PW2_TF_bottom_lineX, PW2_TF_bottom_lineY, PW2_TF_bottom_lineW, PW2_TF_bottom_lineH);
    PW2_TF_bottom_line.backgroundColor = SGSplitLineColor;
    [fourView addSubview:PW2_TF_bottom_line];
    // 输入框
    self.password_again_TF = [[SGTextField alloc] init];
    CGFloat password_again_TFX = PN_TF_bottom_lineX;
    CGFloat password_again_TFY = 0;
    CGFloat password_again_TFW = PN_TF_bottom_lineW;
    CGFloat password_again_TFH = fourViewH - PN_TF_bottom_lineH;
    _password_again_TF.frame = CGRectMake(password_again_TFX, password_again_TFY, password_again_TFW, password_again_TFH);
    _password_again_TF.placeholder = @" 再次新输入密码";
    _password_again_TF.tintColor = SGColorWithRed;
    _password_again_TF.delegate = self;
    _password_again_TF.secureTextEntry = YES;
    _password_again_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password_again_TF.keyboardType = UIKeyboardTypeDefault;
    [fourView addSubview:_password_again_TF];
    
    
    CGFloat bg_viewX = 0;
    CGFloat bg_viewY;
    if (self.fromeVC == 1) {
        bg_viewY = SGMargin + navigationAndStatusBarHeight;
    } else {
        bg_viewY = SGMargin;
    }
    // CGFloat bg_viewY = SGMargin + navigationAndStatusBarHeight;
    CGFloat bg_viewW = SG_screenWidth;
    CGFloat bg_viewH = CGRectGetMaxY(fourView.frame) + 5 * SGMargin;
    bg_view.frame = CGRectMake(bg_viewX, bg_viewY, bg_viewW, bg_viewH);
    bg_view.backgroundColor = [UIColor whiteColor];
    
#pragma mark - - - reseting按钮
    UIButton *resetting_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat resetting_btnX = SGMargin;
    CGFloat resetting_btnY = CGRectGetMaxY(bg_view.frame) + 4 * SGMargin;
    CGFloat resetting_btnW = SG_screenWidth - 2 * resetting_btnX;
    CGFloat resetting_btnH;
    if (iphone5s) {
        resetting_btnH = SGLoginBtnWithIphone5sHeight;
    } else if (iphone6s) {
        resetting_btnH = SGLoginBtnWithIphone6sHeight;
    } else if (iphone6P) {
        resetting_btnH = SGLoginBtnWithIphone6PHeight;
    } else if (iphone4s) {
        resetting_btnH = SGLoginBtnWithIphone4sHeight;
    }
    resetting_btn.frame = CGRectMake(resetting_btnX, resetting_btnY, resetting_btnW, resetting_btnH);
    [resetting_btn setTitle:@"确认重置" forState:(UIControlStateNormal)];
    resetting_btn.backgroundColor = SGCommonRedColor;
    [SGSmallTool SG_smallWithThisView:resetting_btn cornerRadius:5];
    [resetting_btn addTarget:self action:@selector(resetting_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:resetting_btn];
    
#pragma mark - - - 统一设置SGPlaceholderLabel字体的大小
    if (iphone5s) {
        CGFloat labelFont5s = SGLoginRegisterBtnWithIphone5sPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.verification_code_TF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_again_TF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone6s) {
        CGFloat labelFont6s = SGLoginRegisterBtnWithIphone6sPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.verification_code_TF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_again_TF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        
    } else if (iphone6P) {
        CGFloat labelFont6P = SGLoginRegisterBtnWithIphone6PPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
        [self.verification_code_TF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_again_TF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone4s) {
        CGFloat labelFont4s = SGLoginRegisterBtnWithIphone4sPlaceHolderLabelFont;
        [self.phoneNum_TF setValue:[UIFont boldSystemFontOfSize:labelFont4s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_TF setValue:[UIFont boldSystemFontOfSize:labelFont4s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.verification_code_TF setValue:[UIFont boldSystemFontOfSize:labelFont4s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.password_again_TF setValue:[UIFont boldSystemFontOfSize:labelFont4s] forKeyPath:SGPlaceholderLabelFontKey];
    }
}

#pragma mark - - - 获取验证码按钮
- (void)startCountDown:(STCountDownButton *)button {
    if (self.phoneNum_TF.text.length == 0) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"手机号不能为空" delayTime:0.5];
    } else if ([SGHelperTool SG_isPhoneNumber:self.phoneNum_TF.text]) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/sendPCodeb", SGCommonURL];
        //urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phoneReg"] = self.phoneNum_TF.text;
        
        [SGHttpTool postAll:urlStr params:params success:^(id json) {
            SGDebugLog(@"json - - - %@", json);
            if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"短信发送成功, 请稍等..." delayTime:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [button start];
                });
            } else {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", json[@"rmg"]] delayTime:1.0];
            }

        } failure:^(NSError *error) {
            SGDebugLog(@"error - - - %@", error);
        }];
    } else {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的手机号码格式" delayTime:1];
    }
}

#pragma mark - - - 确认重置按钮点击事件
- (void)resetting_btn_action:(UIButton *)button {
    
    if (self.phoneNum_TF.text.length == 0) { // 手机号为空提示
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入手机号码" delayTime:0.5];
    } else if ([SGHelperTool SG_isPhoneNumber:self.phoneNum_TF.text]) { // 手机号正确
        if (self.verification_code_TF.text.length == 0) { // 验证码为空提示
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入验证码" delayTime:0.5];
        } else { // 已输入验证码
            if (self.password_TF.text.length == 0) { // 密码为空提示
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入密码" delayTime:0.5];
            } else {  // 已输入密码
                if (self.password_again_TF.text.length == 0) { // 再次输入密码不能为空
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"再次输入密码不能为空" delayTime:0.5];
                } else {
                    if ([self.password_TF.text isEqualToString:self.password_again_TF.text]) { // 这次才能进行重置
                        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在重置中..." toView:self.navigationController.view];
                        
                        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userLoginPasswordUpdate", SGCommonURL];
                        urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        params[@"phone"] = self.phoneNum_TF.text;
                        params[@"codeReg"] = self.verification_code_TF.text;
                        params[@"newPassword"] = self.password_TF.text;
                        params[@"againPassword"] = self.password_again_TF.text;
                        
                        [SGHttpTool postAll:urlStr params:params success:^(id json) {
                            SGDebugLog(@"json - - - %@", json);
                            if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                                
                                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"重置密码成功" delayTime:1.0];
                                
                                // 2. 进行界面的跳转
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.password_TF resignFirstResponder];
                                    [self.phoneNum_TF resignFirstResponder];
                                    [self.verification_code_TF resignFirstResponder];
                                    [self.password_again_TF resignFirstResponder];
                                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                    JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
                                    appDelegate.window.rootViewController = tabBarC;
                                    tabBarC.selectedIndex = 2;
                                    //JCBAccountSettingVC *ASVC = [[JCBAccountSettingVC alloc] init];
                                    //[self.navigationController popToViewController:ASVC animated:YES];
                                });
                               
                            } else {

                                [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", json[@"rmg"]] delayTime:1.0];
                            }
                        } failure:^(NSError *error) {
                            SGDebugLog(@"error - - - %@", error);

                        }];
                       
                    } else { // 两次输入密码不一致
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"两次输入密码不一致" delayTime:1.0];
                    }
                }
            }
        }
    } else {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的手机号码格式" delayTime:1];
    }
    
    //[SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"重置成功" delayTime:1.0];
}


#pragma mark - - - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)dealloc{
    
}
@end
