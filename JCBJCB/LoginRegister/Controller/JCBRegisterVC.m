//
//  JCBRegisterVC.m
//  JCBJCB
//
//  Created by Sorgle on 2016/10/19.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 广告标示符（IDFA-identifierForIdentifier）
// 这是iOS 6 中另外一个新的方法，advertisingIdentifier是新框架 AdSupport.framework 的一部分
// ASIdentifierManager单例提供了一个方法advertisingIdentifier，通过调用该方法会返回一个NSUUID实例
// 跟CFUUID和NSUUID不一样，广告标示符是由系统存储着的。不过即使这是由系统存储的，但是有几种情况下，会重新生成广告标示符。如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。关于广告标示符的还原，有一点需要注意：如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符

#import "JCBRegisterVC.h"
#import "STCountDownButton.h"
#import <AdSupport/AdSupport.h>
#import "AppDelegate.h"
#import "JCBTabBarController.h"
#import "JCBServiceAgreementVC.h"
#import "SGSettingGesturePWVC.h"


NSString * const kRegisterVC = @"registerVC";


@interface JCBRegisterVC () <UITextFieldDelegate>
@property (nonatomic, strong) SGTextField *phoneNum_TF;
@property (nonatomic, strong) SGTextField *verification_code_TF;
@property (nonatomic, strong) SGTextField *password_TF;
@property (nonatomic, strong) SGTextField *password_again_TF;
@property (nonatomic, strong) UIButton *left_btn; // 协议勾选按钮
@end

@implementation JCBRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 添加手势回收键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [SGNotificationCenter addObserver:self selector:@selector(textFieldKeyBoard) name:kRegisterVC object:nil];

    // 创建子视图
    [self setupSubviews];
}

- (void)textFieldKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark - - - 手势点击事件
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    self.view.transform = CGAffineTransformIdentity;
}

// 创建子视图
- (void)setupSubviews {
    CGFloat iphone4s_height = SGLoginRegisterBGViewWithIphone4sHeight;
    CGFloat iphone5s_height = SGLoginRegisterBGViewWithIphone5sHeight;
    CGFloat iphone6s_height = SGLoginRegisterBGViewWithIphone6sHeight;
    CGFloat iphone6p_height = SGLoginRegisterBGViewWithIphone6PHeight;
    
#pragma mark - - - 手机输入框背景视图
    UIView *oneView = [[UIView alloc] init];
    CGFloat oneViewX = 0;
    CGFloat oneViewY = 30;
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
    CGFloat phoneNum_TFX = PN_TF_bottom_line.SG_x;
    CGFloat phoneNum_TFY = 0;
    CGFloat phoneNum_TFW = PN_TF_bottom_line.SG_width;
    CGFloat phoneNum_TFH = oneViewH - PN_TF_bottom_lineH;
    _phoneNum_TF.frame = CGRectMake(phoneNum_TFX, phoneNum_TFY, phoneNum_TFW, phoneNum_TFH);
    _phoneNum_TF.placeholder = @" 请输入手机号";
    _phoneNum_TF.tintColor = [UIColor redColor];
    _phoneNum_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNum_TF.keyboardType = UIKeyboardTypeNumberPad;
    [oneView addSubview:_phoneNum_TF];
//        _phoneNum_TF.backgroundColor = [UIColor yellowColor];


#pragma mark - - - 验证码输入框背景视图
    UIView *twoView = [[UIView alloc] init];
    CGFloat twoViewX = 0;
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + 2 * SGMargin;
    CGFloat twoViewW = SG_screenWidth;
    CGFloat twoViewH;
    if (iphone5s) {
        twoViewH = iphone5s_height;
    } else if (iphone6s) {
        twoViewH = iphone6s_height;
    } else if (iphone6P) {
        twoViewH = iphone6p_height;
    } else if (iphone4s) {
        twoViewH = 25;
    }
    twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
    //    oneView.backgroundColor = [UIColor redColor];
    [self.view addSubview:twoView];
    
    // 小图标
    UIImageView *VC_imageView = [[UIImageView alloc] init];
    VC_imageView.image = [UIImage imageNamed:@"login_register_verificationCode"];
    CGFloat VC_imageViewX = 10;
    CGFloat VC_imageViewY = 0;
    CGFloat VC_imageViewH = twoView.SG_height;
    CGFloat VC_imageViewW = VC_imageViewH * VC_imageView.image.size.width / VC_imageView.image.size.height - 0.5 * SGSmallMargin;
    VC_imageView.frame = CGRectMake(VC_imageViewX, VC_imageViewY, VC_imageViewW, VC_imageViewH);
    [twoView addSubview:VC_imageView];
    
    // 获取验证码按钮
    CGFloat getVC_btnW = 90;
    CGFloat getVC_btnH = twoViewH;
    CGFloat getVC_btnX = SG_screenWidth - getVC_btnW - SGMargin;
    CGFloat getVC_btnY = 0;
    STCountDownButton *getVC_btn = [[STCountDownButton alloc]initWithFrame:CGRectMake(getVC_btnX, getVC_btnY, getVC_btnW, getVC_btnH)];
    getVC_btn.backgroundColor = [UIColor redColor];
    getVC_btn.layer.cornerRadius = 5;
    getVC_btn.layer.masksToBounds = YES;
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
    CGFloat VC_TFX = VC_TF_bottom_line.SG_x;
    CGFloat VC_TFY = 0;
    CGFloat VC_TFW = VC_TF_bottom_line.SG_width;
    CGFloat VC_TFH = twoViewH - PN_TF_bottom_lineH - 2;
    _verification_code_TF.frame = CGRectMake(VC_TFX, VC_TFY, VC_TFW, VC_TFH);
    _verification_code_TF.placeholder = @" 请输入验证码";
    _verification_code_TF.tintColor = [UIColor redColor];
    _verification_code_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verification_code_TF.keyboardType = UIKeyboardTypeNumberPad;
    [twoView addSubview:_verification_code_TF];
    //    _phoneNum_TF.backgroundColor = [UIColor yellowColor];
    
    
#pragma mark - - - 密码输入框背景视图
    UIView *threeView = [[UIView alloc] init];
    CGFloat threeViewX = 0;
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + 2 * SGMargin;
    CGFloat threeViewW = SG_screenWidth;
    CGFloat threeViewH;
    if (iphone5s) {
        threeViewH = 30;
    } else if (iphone6s) {
        threeViewH = 35;
    } else if (iphone6P) {
        threeViewH = 40;
    } else if (iphone4s) {
        threeViewH = 25;
    }
    threeView.frame = CGRectMake(threeViewX, threeViewY, threeViewW, threeViewH);
    //    threeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:threeView];
    
    // 小图标
    UIImageView *PW_imageView = [[UIImageView alloc] init];
    PW_imageView.image = [UIImage imageNamed:@"login_register_password"];
    CGFloat PW_imageViewX = 10;
    CGFloat PW_imageViewY = 0;
    CGFloat PW_imageViewH = threeView.SG_height;
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
    _password_TF.placeholder = @" 请输入密码，长度8～16位，必须包含字母";
    _password_TF.tintColor = [UIColor redColor];
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
    CGFloat fourViewH;
    if (iphone5s) {
        fourViewH = 30;
    } else if (iphone6s) {
        fourViewH = 35;
    } else if (iphone6P) {
        fourViewH = 40;
    } else if (iphone4s) {
        fourViewH = 25;
    }
    fourView.frame = CGRectMake(fourViewX, fourViewY, fourViewW, fourViewH);
    //    fourView.backgroundColor = [UIColor redColor];
    [self.view addSubview:fourView];
    
    // 小图标
    UIImageView *PW2_imageView = [[UIImageView alloc] init];
    PW2_imageView.image = [UIImage imageNamed:@"login_register_password"];
    CGFloat PW2_imageViewX = 10;
    CGFloat PW2_imageViewY = 0;
    CGFloat PW2_imageViewH = fourView.SG_height;
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
    CGFloat password_again_TFX = PN_TF_bottom_line.SG_x;
    CGFloat password_again_TFY = 0;
    CGFloat password_again_TFW = PN_TF_bottom_line.SG_width;
    CGFloat password_again_TFH = fourViewH - PN_TF_bottom_lineH;
    _password_again_TF.frame = CGRectMake(password_again_TFX, password_again_TFY, password_again_TFW, password_again_TFH);
    _password_again_TF.placeholder = @" 再次输入密码";
    _password_again_TF.tintColor = SGCommonRedColor;
    _password_again_TF.delegate = self;
    _password_again_TF.secureTextEntry = YES;
    _password_again_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _password_again_TF.backgroundColor = [UIColor yellowColor];
    [fourView addSubview:_password_again_TF];


#pragma mark - - - 注册按钮
    UIButton *register_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat register_btnX = SGMargin;
    CGFloat register_btnY = CGRectGetMaxY(fourView.frame) + 3 * SGMargin;
    CGFloat register_btnW = SG_screenWidth - 2 * register_btnX;
    CGFloat register_btnH;
    if (iphone5s) {
        register_btnH = SGLoginBtnWithIphone5sHeight;
    } else if (iphone6s) {
        register_btnH = SGLoginBtnWithIphone6sHeight;
    } else if (iphone6P) {
        register_btnH = SGLoginBtnWithIphone6PHeight;
    } else if (iphone4s) {
        register_btnH = SGLoginBtnWithIphone4sHeight;
    }
    register_btn.frame = CGRectMake(register_btnX, register_btnY, register_btnW, register_btnH);
    [register_btn setTitle:@"注册" forState:(UIControlStateNormal)];
    register_btn.backgroundColor = [UIColor redColor];
    [SGSmallTool SG_smallWithThisView:register_btn cornerRadius:5];
    [register_btn addTarget:self action:@selector(register_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:register_btn];
    
#pragma mark - - - 最底部试图及子控件
    UIView *bottomView = [[UIView alloc] init];
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = CGRectGetMaxY(register_btn.frame) + 2 * SGMargin;
    CGFloat bottomViewW = SG_screenWidth;
    CGFloat bottomViewH = 20;
    bottomView.frame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    [self.view addSubview:bottomView];
//    bottomView.backgroundColor = [UIColor redColor];
    
    UILabel *center_label = [[UILabel alloc] init];
    center_label.SG_y = 0;
    center_label.SG_height = bottomViewH;
    center_label.SG_width = 87;
    center_label.SG_centerX = bottomView.SG_centerX * 0.9;
    center_label.text = @"我已阅读并同意";
    center_label.textColor = SGrayColor(168);
    center_label.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:center_label];
//    center_label.backgroundColor = [UIColor yellowColor];
    
    // check 按钮
    self.left_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_left_btn setImage:[UIImage imageNamed:@"login_register_check"] forState:(UIControlStateNormal)];
    [_left_btn setImage:[UIImage imageNamed:@"login_register_check_selected"] forState:(UIControlStateSelected)];
    _left_btn.selected = YES;
    CGFloat left_btnX = CGRectGetMinX(center_label.frame) - bottomViewH;
    CGFloat left_btnY = 0;
    CGFloat left_btnW = bottomViewH;
    CGFloat left_btnH = bottomViewH;
    _left_btn.frame = CGRectMake(left_btnX, left_btnY, left_btnW, left_btnH);
    [_left_btn addTarget:self action:@selector(check_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:_left_btn];
    
    // 服务协议按钮
    UIButton *right_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat right_btnX = CGRectGetMaxX(center_label.frame);
    CGFloat right_btnY = 0;
    CGFloat right_btnW = 80;
    CGFloat right_btnH = bottomViewH;
    right_btn.frame = CGRectMake(right_btnX, right_btnY, right_btnW, right_btnH);
    [right_btn setTitle:@"《服务协议》" forState:(UIControlStateNormal)];
    [right_btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    right_btn.titleLabel.font = [UIFont systemFontOfSize:12];
//    right_btn.backgroundColor = [UIColor yellowColor];
    right_btn.contentEdgeInsets = UIEdgeInsetsMake(0, - 5, 0, 0);
    [right_btn addTarget:self action:@selector(service_btn_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:right_btn];
    

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
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/sendPCode", SGCommonURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phoneReg"] = self.phoneNum_TF.text;
        [SGHttpTool postAll:urlStr params:params success:^(id json) {
            if ([json[@"rcd"] isEqualToString:@"M0008_7"]) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"该手机号码已经注册过了" delayTime:1.0];
            } else if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"短信发送成功, 请稍等..." delayTime:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [button start];
                });
            }
            SGDebugLog(@"json - - - %@", json);
        } failure:^(NSError *error) {
            SGDebugLog(@"error - - - %@", error);
        }];
    } else {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的手机号码格式" delayTime:1];
    }
}

#pragma mark - - - 注册按钮点击事件
- (void)register_btn_action:(UIButton *)button {
    [self.phoneNum_TF endEditing:YES];
    [self.verification_code_TF endEditing:YES];
    [self.password_TF endEditing:YES];
    [self.password_again_TF endEditing:YES];
    self.view.transform = CGAffineTransformIdentity;


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
                    if ([self.password_TF.text isEqualToString:self.password_again_TF.text]) { // 这次才能进行注册
                        
                        if (self.left_btn.selected == YES) { // 判断协议是否勾选
                            [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在注册中..." toView:self.navigationController.view];
                            
                            NSString *UUIDString =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                            
                            NSString *urlStr = [NSString stringWithFormat:@"%@/rest/reg", SGCommonURL];
                            // 参数
                            NSString *userDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:userDeviceToken_key];
                            if (userDeviceToken == nil) {
                                userDeviceToken = @"";
                            } else {
                                SGDebugLog(@"strToken = %@",userDeviceToken);
                            }
                            
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            params[@"user.phone"] = self.phoneNum_TF.text;
                            params[@"codeReg"] = self.verification_code_TF.text;
                            params[@"user.password"] = self.password_TF.text;
                            params[@"way"] = @"3";
                            params[@"idfa"] = UUIDString;
                            params[@"appType"] = @"0";
                            params[@"deviceToken"] = userDeviceToken;
                            params[@"placeName"] = @"";
                            
                            [SGHttpTool postAll:urlStr params:params success:^(id json) {
                                SGDebugLog(@"json - - - %@", json);
                                [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                                if ([json[@"rcd"] isEqualToString:@"M0008_3"]) {
                                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"密码必须包含字母" delayTime:1.0];
                                } else if ([json[@"rcd"] isEqualToString:@"M0008_4"]) {
                                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"密码长度必须在8-16个字符之间" delayTime:1.0];
                                } else if ([json[@"rcd"] isEqualToString:@"M0008_1"]) {
                                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"短信验证码不正确" delayTime:1.0];
                                } else if ([json[@"rcd"] isEqualToString:@"R0001"]){
                                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"恭喜您注册成功" delayTime:1.0];
                                    
                                    SGDebugLog(@"注册成功");
                                    
                                    // 注册成功 存贮用户信息
                                    [[NSUserDefaults standardUserDefaults] setObject:json[@"userId"] forKey:userId]; // 存储用户 userId
                                    [[NSUserDefaults standardUserDefaults] setObject:json[@"token"] forKey:userAccessToken]; // 存储用户 accessToken
                                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:signIn];

                                    // 立即同步
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    // 进行界面跳转
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark - - - 注册成功之后记录用户第一次注册
                                        // 保存第一次注册成功的 key 值
                                        [SGUserDefaults setObject:@"YES" forKey:isSuccesfulRegistration];
                                        // 立即同步
                                        [SGUserDefaults synchronize];
                                        
#pragma mark - - - 注册成功之后进行界面的跳转
                                        UIAlertController *alertC = [UIAlertController SG_alertControllerWithTitle:@"为了保护您的账户资金安全，请开启手势密码" message:@"您也可以在“我的-设置-手势密码”进行设置" sureBtn:@"立即开启" cancelBtn:@"下次再说" preferredStyle:(UIAlertControllerStyleAlert) sureBtnAction:^{
                                            [JCBSingletonManager sharedSingletonManager].isRegisterVCToSettingGesturePWVC = YES;
                                            
                                            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                            SGSettingGesturePWVC *settingGPWVC = [[SGSettingGesturePWVC alloc] init];
                                            appDelegate.window.rootViewController = settingGPWVC;

                                        } cancelBtnAction:^{
                                            
                                            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                            JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
                                            appDelegate.window.rootViewController = tabBarC;
                                            tabBarC.selectedIndex = 0;
                                        }];
                                        [self presentViewController:alertC animated:YES completion:^{
                                            
                                        }];
             
#pragma mark - - - 注册成功之后让用户自动登录
                                        NSString *login_urlStr = [NSString stringWithFormat:@"%@/rest/login", SGCommonURL];
                                        
                                        // 记录哪部手机
                                        NSString *userDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:userDeviceToken_key];
                                        // 立即同步
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        // 参数
                                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                                        params[@"username"] = self.phoneNum_TF.text;
                                        params[@"password"] = self.password_TF.text;
                                        params[@"deviceToken"] = userDeviceToken;
                                        
                                        [SGHttpTool postAll:login_urlStr params:params success:^(id json) {
                                            
                                            // 1. 存储用户 id 以及 accessToken
                                            [[NSUserDefaults standardUserDefaults] setObject:json[@"userId"] forKey:userId];
                                            [[NSUserDefaults standardUserDefaults] setObject:json[@"token"] forKey:userAccessToken];
                                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:signIn];
                                            // 立即同步
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            SGDebugLog(@"登录成功");
                                            
                                        } failure:^(NSError *error) {
                                            SGDebugLog(@"登录error");
                                        }];
                                        
                                    });
                                    
                                    // 进行界面跳转
                                    /*
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                        JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
                                        appDelegate.window.rootViewController = tabBarC;
                                        tabBarC.selectedIndex = 0;
                                        
                                        
                                        UIWindow *window = [UIApplication sharedApplication].keyWindow;

                                        UIView *view_after_SR = [[UIView alloc] init];
                                        view_after_SR.frame = window.frame;
                                        view_after_SR.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
                                        [window addSubview:view_after_SR];
                                    });
                                     */
                                }
                            } failure:^(NSError *error) {
                                [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"注册失败" toView:self.navigationController.view];
                                });
                                SGDebugLog(@"error - - - %@", error);
                            }];

                        } else {
                            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请遵守服务协议" delayTime:1.0];
                        }
                        
                    } else { // 两次输入密码不一致
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"两次输入密码不一致" delayTime:1.0];
                    }
                }
            }
        }
    } else {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入正确的手机号码格式" delayTime:1];
    }
}

#pragma mark - - - check 按钮
- (void)check_btn_action:(UIButton *)button {
    if (button.selected == YES) {
        button.selected = NO;
    } else {
        button.selected = YES;
    }
}

#pragma mark - - - 服务协议按钮
- (void)service_btn_action:(UIButton *)button {
    JCBServiceAgreementVC *SAVC = [[JCBServiceAgreementVC alloc] init];
    [self.navigationController pushViewController:SAVC animated:YES];
}

#pragma mark - - - UITextField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SGDebugLog(@" - - - - ");
    if (iphone5s) {
        if (textField == self.password_again_TF) {
            self.view.transform = CGAffineTransformMakeTranslation(0, - 2 * SGMargin);
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


- (void)dealloc {
    SGDebugLog(@"JCBRegisterVC - - dealloc");
    [SGNotificationCenter removeObserver:self name:kRegisterVC object:nil];
}


@end


