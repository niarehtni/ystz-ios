//
//  JCBRechargeVC.m
//  JCBJCB
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRechargeVC.h"
#import "JCBRechargeRecordVC.h"
#import "JCBTransactionPWSettingNextVC.h"
#import "JCBRechargeModel.h"
#import <BaoFooPay/BaoFooPay.h>
#import "JCBBaoFuPayModel.h"
#import "JCBBingCardAuthenticationVC.h"
#import "JCBRongBaoPayVC.h"
#import "JCBLimitDescriptionVC.h"
#import "JCBBindCardSMSViewController.h"

@interface JCBRechargeVC () <BaofooSdkDelegate, SGAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UILabel *useMoneyLabel;
@property (nonatomic, strong) UITextField *rechargeMoneyTF;
@property (nonatomic, strong) UITextField *changePWTF;
@property (nonatomic, strong) UIView *oneView;
@property (nonatomic, strong) UIView *twoView; // 交易密码 view
@property (nonatomic, strong) UIButton *forgetBtn; // 忘记密码
@property (nonatomic, strong) UIView *threeView; // 支付方式 view
// 支付方式
@property (nonatomic, strong) UIButton *paymentMethodBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *surePayBtn;
@property (nonatomic, strong) NSDictionary *dataSource_dict;
/// 提示视图
@property (nonatomic, strong) UIView *prompt_view;


@end

@implementation JCBRechargeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     //[self getDataSourceFromeNetWorking];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SGCommonBgColor;
    
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(panGestureRecognizer_action)];

    // 注册观察者
    [SGNotificationCenter addObserver:self selector:@selector(getDataSourceFromeNetWorking) name:@"rechargeGetDataSource" object:nil];
    [self setupSubviews];
}

- (void)dealloc {
    [SGNotificationCenter removeObserver:self];
}

- (void)panGestureRecognizer_action {
    [self.view endEditing:YES];
}

- (void)getDataSourceFromeNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/rechargeTo", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"rechargeTo - dictionary - - - %@", dictionary);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        self.dataSource_dict = dictionary;
        
        JCBRechargeModel *model = [JCBRechargeModel mj_objectWithKeyValues:dictionary];
        // 可用余额
        if ([dictionary[@"rcd"] isEqualToString:@"M00010"]) { // 用户没有绑卡
            self.useMoneyLabel.text = [NSString stringWithFormat:@"%.2f", [[JCBSingletonManager sharedSingletonManager].user_money floatValue]];
            
            // 先移除
            [_prompt_view removeFromSuperview];
            [_twoView removeFromSuperview];
            [_forgetBtn removeFromSuperview];
            [_threeView removeFromSuperview];
            [_surePayBtn removeFromSuperview];
            [_sureBtn removeFromSuperview];
            [self setupSureBtn];
            _bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_sureBtn.frame) + 5 * SGMargin);
            
        } else { // 用户已经绑卡
            
            [_bgScrollView addSubview:_twoView];
            [_bgScrollView addSubview:_forgetBtn];
            [_bgScrollView addSubview:_threeView];
    
            self.useMoneyLabel.text = model.ableMoney;
            [self.paymentMethodBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_bankCard_%@_icon", model.bankId]] forState:(UIControlStateNormal)];
            [self.paymentMethodBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_bankCard_%@_icon", model.bankId]] forState:(UIControlStateHighlighted)];
            // 支付方式
            NSString *cardNoStr = [NSString stringWithFormat:@"%@", model.cardNo];
            NSString *lastFourCardNo = [cardNoStr substringFromIndex:cardNoStr.length - 4];
            [self.paymentMethodBtn setTitle:[NSString stringWithFormat:@"%@(尾号为：%@)", model.bankName, lastFourCardNo] forState:(UIControlStateNormal)];
            // 先移除，再创建
            [_sureBtn removeFromSuperview];
            [_surePayBtn removeFromSuperview];
            [self setupSurePayBtn];
            _bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_surePayBtn.frame) + 5 * SGMargin);
        }
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];

#pragma mark - - - 数据请求失败
            // 先移除
            [_twoView removeFromSuperview];
            [_forgetBtn removeFromSuperview];
            [_threeView removeFromSuperview];
            [_surePayBtn removeFromSuperview];
            [_sureBtn removeFromSuperview];
            [self setupSureBtn];
            _bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_sureBtn.frame) + 5 * SGMargin);
        });
    }];
}

- (void)setupSureBtn {
    self.sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat sureBtnX = SGMargin;
    CGFloat sureBtnY;
    sureBtnY = CGRectGetMaxY(_oneView.frame) + 2 * SGMargin;
    CGFloat sureBtnW = SG_screenWidth - 2 * sureBtnX;
    CGFloat sureBtnH = _threeView.SG_height;
    _sureBtn.frame = CGRectMake(sureBtnX, sureBtnY, sureBtnW, sureBtnH);
    _sureBtn.backgroundColor = SGColorWithRed;
    [_sureBtn setTitle:@"确认充值" forState:(UIControlStateNormal)];
    //[sureBtn setTitleColor:SGColorWithBlackOfDark forState:(UIControlStateNormal)];
    [_sureBtn addTarget:self action:@selector(sureBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [SGSmallTool SG_smallWithThisView:_sureBtn cornerRadius:5];
    [_bgScrollView addSubview:_sureBtn];
}

- (void)setupSurePayBtn {
    self.surePayBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat sureBtnX = SGMargin;
    CGFloat sureBtnY;
    sureBtnY = CGRectGetMaxY(_threeView.frame) + 2 * SGMargin;
    CGFloat sureBtnW = SG_screenWidth - 2 * sureBtnX;
    CGFloat sureBtnH = _threeView.SG_height;
    _surePayBtn.frame = CGRectMake(sureBtnX, sureBtnY, sureBtnW, sureBtnH);
    _surePayBtn.backgroundColor = SGColorWithRed;
    [_surePayBtn setTitle:@"确认充值" forState:(UIControlStateNormal)];
    //[sureBtn setTitleColor:SGColorWithBlackOfDark forState:(UIControlStateNormal)];
    [_surePayBtn addTarget:self action:@selector(sureBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [SGSmallTool SG_smallWithThisView:_surePayBtn cornerRadius:5];
    [_bgScrollView addSubview:_surePayBtn];
}

- (void)setupSubviews {
    self.bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - navigationAndStatusBarHeight - 44 - 1);
    _bgScrollView.backgroundColor = SGCommonBgColor;
    [self.view addSubview:_bgScrollView];
    
    UIView *bgTopView = [[UIView alloc] init];
    CGFloat bgTopViewX = 0;
    CGFloat bgTopViewY = SGMargin;
    CGFloat bgTopViewW = SG_screenWidth;
    CGFloat bgTopViewH = _bgScrollView.SG_height * 0.29;
    bgTopView.frame = CGRectMake(bgTopViewX, bgTopViewY, bgTopViewW, bgTopViewH);
    bgTopView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:bgTopView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    CGFloat textLabelW = 125;
    CGFloat textLabelH = 22;
    CGFloat textLabelX = (SG_screenWidth - textLabelW) * 0.4;
    CGFloat textLabelY = 0.19 * bgTopViewH;
    textLabel.text = @"可用余额（元）";
    //textLabel.backgroundColor = SGColorWithRandom;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    [bgTopView addSubview:textLabel];
    
    UIButton *rechargeRecord = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat rechargeRecordX = CGRectGetMaxX(textLabel.frame);
    CGFloat rechargeRecordY = textLabelY;
    CGFloat rechargeRecordW = 72;
    CGFloat rechargeRecordH = textLabelH;
    //forgetBtn.backgroundColor = SGColorWithRandom;
    rechargeRecord.frame = CGRectMake(rechargeRecordX, rechargeRecordY, rechargeRecordW, rechargeRecordH);
    rechargeRecord.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    [rechargeRecord setTitle:@"充值记录" forState:(UIControlStateNormal)];
    [rechargeRecord setTitleColor:SGColorWithRed forState:(UIControlStateNormal)];
    [rechargeRecord addTarget:self action:@selector(rechargeRecordBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [SGSmallTool SG_smallWithThisView:rechargeRecord cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:rechargeRecord borderWidth:1 borderColor:SGColorWithRed];
    [bgTopView addSubview:rechargeRecord];
    
    self.useMoneyLabel = [[UILabel alloc] init];
    CGFloat useMoneyLabelX = 0;
    CGFloat useMoneyLabelY = 0.45 * bgTopViewH;
    CGFloat useMoneyLabelW = SG_screenWidth;
    CGFloat useMoneyLabelH = 50;
    _useMoneyLabel.text = @"0.00";
    _useMoneyLabel.font = [UIFont systemFontOfSize:32];
    //_useMoneyLabel.backgroundColor = SGColorWithRandom;
    _useMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _useMoneyLabel.frame = CGRectMake(useMoneyLabelX, useMoneyLabelY, useMoneyLabelW, useMoneyLabelH);
    [bgTopView addSubview:_useMoneyLabel];
    
#pragma mark - - - oneView
    self.oneView = [[UIView alloc] init];
    CGFloat oneViewX = 0;
    CGFloat oneViewY = CGRectGetMaxY(bgTopView.frame) + SGMargin;
    CGFloat oneViewW = SG_screenWidth;
    CGFloat oneViewH = 0;
    if (iphone5s) {
        oneViewH = 44;
    } else if (iphone6s) {
        oneViewH = 47;
    } else if (iphone6P) {
        oneViewH = 50;
    } else if (iphone4s) {
        oneViewH = 41;
    }
    
    _oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
    _oneView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:_oneView];
    
    UIImageView *oneImageView = [[UIImageView alloc] init];
    oneImageView.image = [UIImage imageNamed:@"mine_rechangeCash_money_icon"];
    CGFloat oneImageViewW = oneImageView.image.size.width;
    CGFloat oneImageViewH = oneImageView.image.size.height;
    CGFloat oneImageViewX = SGMargin;
    CGFloat oneImageViewY = (oneViewH - oneImageViewH) * 0.5;
    oneImageView.frame = CGRectMake(oneImageViewX, oneImageViewY, oneImageViewW, oneImageViewH);
    [_oneView addSubview:oneImageView];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    CGFloat moneyLabelW = 20;
    CGFloat moneyLabelH = oneViewH;
    CGFloat moneyLabelX = SG_screenWidth - SGMargin - moneyLabelW;
    CGFloat moneyLabelY = 0;
    moneyLabel.text = @"元";
    moneyLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //moneyLabel.backgroundColor = SGColorWithRandom;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.frame = CGRectMake(moneyLabelX, moneyLabelY, moneyLabelW, moneyLabelH);
    [_oneView addSubview:moneyLabel];
    
    self.rechargeMoneyTF = [[UITextField alloc] init];
    CGFloat turnOutMoneyTFH = 30;
    CGFloat turnOutMoneyTFX = CGRectGetMaxX(oneImageView.frame) + SGMargin;
    CGFloat turnOutMoneyTFY = (oneViewH - turnOutMoneyTFH) * 0.5;
    CGFloat turnOutMoneyTFW = SG_screenWidth - turnOutMoneyTFX - moneyLabelW - 2 * SGMargin;
    //_turnOutMoneyTF.backgroundColor = SGColorWithRandom;
    _rechargeMoneyTF.frame = CGRectMake(turnOutMoneyTFX, turnOutMoneyTFY, turnOutMoneyTFW, turnOutMoneyTFH);
    _rechargeMoneyTF.placeholder = @"请输入充值金额（最低 3 元）";
    _rechargeMoneyTF.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _rechargeMoneyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _rechargeMoneyTF.keyboardType = UIKeyboardTypeDefault;
    [_oneView addSubview:_rechargeMoneyTF];
    
#pragma mark - - - 提示银行限额 view
    self.prompt_view = [[UIView alloc] init];
    self.prompt_view.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame), SG_screenWidth, 3 * SGMargin);
    //self.prompt_view.backgroundColor = [UIColor yellowColor];
    
    UIButton *promptBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [promptBtn setBackgroundImage:[UIImage imageNamed:@"mine_recharge_prompt_icon"] forState:(UIControlStateNormal)];
    CGFloat promptBtnW = 15;
    CGFloat promptBtnH = promptBtnW;
    CGFloat promptBtnX = SG_screenWidth - promptBtnW - SGMargin;
    CGFloat promptBtnY = 0.5 * (self.prompt_view.SG_height - promptBtnH);
    promptBtn.frame = CGRectMake(promptBtnX, promptBtnY, promptBtnW, promptBtnH);
    [promptBtn addTarget:self action:@selector(promptBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *promptLabel = [[UILabel alloc] init];

    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = 0;
    CGFloat promptLabelW = SG_screenWidth - promptBtnW - 2 * SGMargin;
    CGFloat promptLabelH = self.prompt_view.SG_height;
    promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    //promptLabel.backgroundColor = [UIColor redColor];
    promptLabel.textAlignment = NSTextAlignmentRight;
    promptLabel.text = @"本次支付上限 5000 元，日限额 20 万";
    promptLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    promptLabel.textColor = SGColorWithDarkGrey;

    [self.prompt_view addSubview:promptBtn];
    [self.prompt_view addSubview:promptLabel];
    [self.view addSubview:_prompt_view];
    
#pragma mark - - - twoView
//    self.twoView = [[UIView alloc] init];
//    CGFloat twoViewX = 0;
//    CGFloat twoViewY = CGRectGetMaxY(_prompt_view.frame);
//    CGFloat twoViewW = SG_screenWidth;
//    CGFloat twoViewH = oneViewH;
//    _twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
//    _twoView.backgroundColor = SGColorWithWhite;
//
//    UIImageView *twoImageView = [[UIImageView alloc] init];
//    twoImageView.image = [UIImage imageNamed:@"mine_rechangeCash_lock_icon"];
//    CGFloat twoImageViewW = twoImageView.image.size.width;
//    CGFloat twoImageViewH = twoImageView.image.size.height;
//    CGFloat twoImageViewX = SGMargin;
//    CGFloat twoImageViewY = (twoViewH - twoImageViewH) * 0.5;
//    twoImageView.frame = CGRectMake(twoImageViewX, twoImageViewY, twoImageViewW, twoImageViewH);
//    [_twoView addSubview:twoImageView];
    
//    self.changePWTF = [[UITextField alloc] init];
//    CGFloat changePWTFH = turnOutMoneyTFH;
//    CGFloat changePWTFX = CGRectGetMaxX(oneImageView.frame) + SGMargin;
//    CGFloat changePWTFY = (twoViewH - changePWTFH) * 0.5;
//    CGFloat changePWTFW = SG_screenWidth - changePWTFX - 2 * SGMargin;
//    //_changePWTF.backgroundColor = SGColorWithRandom;
//    _changePWTF.font = [UIFont systemFontOfSize:SGTextFontWith15];
//    _changePWTF.frame = CGRectMake(changePWTFX, changePWTFY, changePWTFW, changePWTFH);
//    _changePWTF.placeholder = @"请输入交易密码";
//    _changePWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _changePWTF.keyboardType = UIKeyboardTypeDefault;
//    _changePWTF.delegate = self;
//    _changePWTF.secureTextEntry = YES;
//    [_twoView addSubview:_changePWTF];
    
#pragma mark - - - 忘记密码
//    self.forgetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    CGFloat forgetBtnW = 72;
//    CGFloat forgetBtnH = 30;
//    CGFloat forgetBtnX = SG_screenWidth - forgetBtnW;
//    CGFloat forgetBtnY = CGRectGetMaxY(_twoView.frame);
//    //forgetBtn.backgroundColor = SGColorWithRandom;
//    _forgetBtn.frame = CGRectMake(forgetBtnX, forgetBtnY, forgetBtnW, forgetBtnH);
//    _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
//    [_forgetBtn setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
//    [_forgetBtn setTitleColor:SGColorWithBlackOfDark forState:(UIControlStateNormal)];
//    [_forgetBtn addTarget:self action:@selector(forgetBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    
#pragma mark - - - threeView
    self.threeView = [[UIView alloc] init];
    CGFloat threeViewX = 0;
//    CGFloat threeViewY = CGRectGetMaxY(_forgetBtn.frame);
    CGFloat threeViewY = CGRectGetMaxY(self.prompt_view.frame);
    CGFloat threeViewW = SG_screenWidth;
//    CGFloat threeViewH = twoViewH;
    CGFloat threeViewH = oneViewH;
    _threeView.frame = CGRectMake(threeViewX, threeViewY, threeViewW, threeViewH);
    _threeView.backgroundColor = SGColorWithWhite;

    UILabel *paymentMethodLabel = [[UILabel alloc] init];
    CGFloat paymentMethodLabelX = SGMargin;
    CGFloat paymentMethodLabelY = 0;
    CGFloat paymentMethodLabelW = 65;
    CGFloat paymentMethodLabelH = threeViewH;
    paymentMethodLabel.text = @"支付方式";
    //paymentMethodLabel.backgroundColor = SGColorWithRandom;
    paymentMethodLabel.font = [UIFont boldSystemFontOfSize:SGTextFontWith15];
    paymentMethodLabel.frame = CGRectMake(paymentMethodLabelX, paymentMethodLabelY, paymentMethodLabelW, paymentMethodLabelH);
    [_threeView addSubview:paymentMethodLabel];
    
    self.paymentMethodBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat paymentMethodBtnX = CGRectGetMaxX(paymentMethodLabel.frame) + SGMargin;
    CGFloat paymentMethodBtnY = 0;
    CGFloat paymentMethodBtnW = 200;
    CGFloat paymentMethodBtnH = threeViewH;
    _paymentMethodBtn.frame = CGRectMake(paymentMethodBtnX, paymentMethodBtnY, paymentMethodBtnW, paymentMethodBtnH);
    //_paymentMethodBtn.backgroundColor = SGColorWithRandom;
    _paymentMethodBtn.imageEdgeInsets = UIEdgeInsetsMake(0, - SGMargin, 0, 0);
    [_paymentMethodBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _paymentMethodBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [_threeView addSubview:_paymentMethodBtn];
    
}

#pragma mark - - - 充值记录按钮的点击事件
- (void)rechargeRecordBtn_action {
    JCBRechargeRecordVC *RRVC = [[JCBRechargeRecordVC alloc] init];
    [self.navigationController pushViewController:RRVC animated:YES];
}

- (void)promptBtnAction {
    JCBLimitDescriptionVC *LDVC = [[JCBLimitDescriptionVC alloc] init];
    [self.navigationController pushViewController:LDVC animated:YES];
}
    
#pragma mark - - - 忘记密码按钮的点击事件
- (void)forgetBtn_action {
    JCBTransactionPWSettingNextVC *forgetPWVC = [[JCBTransactionPWSettingNextVC alloc] init];
    [self.navigationController pushViewController:forgetPWVC animated:YES];
}

#pragma mark - - - 确认充值按钮的点击事件
- (void)sureBtn_action {
    
    if ([self.dataSource_dict[@"rcd"] isEqualToString:@"M00010"]) { // 用户没有绑卡
        
        if (self.rechargeMoneyTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入充值金额" delayTime:1.0];
        } else if ([self.rechargeMoneyTF.text integerValue] < 3) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"最低充值金额不得少于3元" delayTime:1.5];
        } else {
            JCBBingCardAuthenticationVC *BCAVC = [[JCBBingCardAuthenticationVC alloc] init];
            BCAVC.bingCardMoney = self.rechargeMoneyTF.text;
            [self.navigationController pushViewController:BCAVC animated:YES];
        }
        
    }else if([self.dataSource_dict[@"rcd"] isEqualToString:@"M00020"]) {
        JCBBindCardSMSViewController *vc = [[JCBBindCardSMSViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else { // 用户已经绑卡
        
        if (self.rechargeMoneyTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入充值金额" delayTime:1.0];
        } else if ([self.rechargeMoneyTF.text integerValue] < 3) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"最低充值金额不得少于3元" delayTime:1.5];
        } else {
//            if (self.changePWTF.text.length == 0) {
//                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入交易密码" delayTime:1.0];
//            } else {
                [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在加载中，请稍等" toView:self.navigationController.view];
                NSString *urlStr = [NSString stringWithFormat:@"%@/rest/rechargeSaveHnew", SGCommonURL];
                urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                
                JCBRechargeModel *model = (JCBRechargeModel *)self.dataSource_dict;
                SGDebugLog(@"model - - - %@", model);
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"userAccountRecharge.money"] = self.rechargeMoneyTF.text;
                params[@"realName"] = self.dataSource_dict[@"realName"];
                params[@"idNo"] = self.dataSource_dict[@"cardId"];
                params[@"cardNo"] = self.dataSource_dict[@"cardNo"];
//                params[@"safepwd"] = self.changePWTF.text;
                params[@"registerTime"] = self.dataSource_dict[@"registerTime"];
                
                [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    SGDebugLog(@"rechargeSaveHnew - dictionary - - - %@", dictionary);
                    
                    if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) {
                        JCBRongBaoPayVC *rongBaoVC = [[JCBRongBaoPayVC alloc] init];
                        rongBaoVC.user_order_no = dictionary[@"order_no"];
                        [self.navigationController pushViewController:rongBaoVC animated:YES];
                        
                    } else {
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:dictionary[@"rmg"] delayTime:1.0];
                    }
                } failure:^(NSError *error) {
                    SGDebugLog(@"error - - -  %@", error);
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.navigationController.view];
                }];
                
//            }
        }

    }
    
}

#pragma mark - - - UITextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


#pragma mark - - - BaofooDelegate
-(void)callBack:(NSString *)params {
   SGDebugLog(@"params - - - %@",params);
   
   if ([params isEqualToString:@"0,订单取消"]) {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"温馨提示：您的订单已取消" delayTime:1.5];
       });
   } else {
       SGAlertView *alertV = [SGAlertView alertViewWithTitle:@"温馨提示" delegate:self contentTitle:[NSString stringWithFormat:@"支付结果:%@",params] alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
       [alertV show];
   }
   
}
                                   
#pragma mark - - - SGAlertViewDelegate
- (void)didSelectedRightButtonClick {
   [self.navigationController popToRootViewControllerAnimated:YES];
}

                                   
@end
