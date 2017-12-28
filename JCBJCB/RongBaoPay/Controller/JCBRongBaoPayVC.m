//
//  JCBRongBaoPayVC.m
//  JCBJCB
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRongBaoPayVC.h"
#import "STCountDownButton.h"
#import "JCBPayResultVC.h"
#import "UMMobClick/MobClick.h"
#import "JCBBingCardAuthenticationVC.h"

@interface JCBRongBaoPayVC () <UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UILabel *payMoney_Label;
@property (nonatomic, strong) UILabel *merchant_order_no_Label;
@property (nonatomic, strong) UILabel *payTime_Label;
@property (nonatomic, strong) UILabel *bank_Label;
@property (nonatomic, strong) UILabel *bank_no_Label;
@property (nonatomic, strong) UILabel *name_Label;
@property (nonatomic, strong) UILabel *card_id_Label;
@property (nonatomic, strong) UILabel *phone_Label;
@property (nonatomic, strong) UITextField *verification_code_TF;
@property (nonatomic, strong) STCountDownButton *getVC_btn;
@property (nonatomic, strong) UIButton *payBtn; // 确定支付按钮

@property (nonatomic, strong) NSDictionary *dataSource_dict;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalSecond;
@property (nonatomic, strong) NSString *pushTo_resultMoney;

@end

@implementation JCBRongBaoPayVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 友盟统计
    [MobClick beginLogPageView:@"RongBao"]; // ("RongBao"为页面名称，可自定义)
    
    [self getDataWithUserCenter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 友盟统计
    [MobClick endLogPageView:@"RongBao"];
}

- (void)getDataWithUserCenter {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/payOrder", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.user_order_no;

    [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
        SGDebugLog(@"payOrder - json - - - %@", dictionary);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        self.dataSource_dict = dictionary;
        
        // 赋值
        self.payMoney_Label.text = [NSString stringWithFormat:@"%@元", dictionary[@"money"]];
        self.merchant_order_no_Label.text = [NSString stringWithFormat:@"%@", dictionary[@"order_no"]];
        self.payTime_Label.text = [NSString stringWithFormat:@"%@", dictionary[@"create_time"]];
        
        self.bank_Label.text = [NSString stringWithFormat:@"%@", dictionary[@"bank_name"]];
        
        // bank_no
        NSString *bank_no = dictionary[@"bank_no"];
        bank_no = [bank_no SG_replaceCharcterInRange:NSMakeRange(0, bank_no.length - 4) withCharcter:@"**"];
        self.bank_no_Label.text = [NSString stringWithFormat:@"储蓄卡 ｜ %@", bank_no];
        
        // name
        NSString *name = dictionary[@"name"];
        name = [name SG_replaceCharcterInRange:NSMakeRange(0, name.length - 1) withCharcter:@"**"];
        self.name_Label.text = [NSString stringWithFormat:@"%@", name];
        
        // 身份证号
        NSString *card_id = dictionary[@"card_id"];
        card_id = [card_id SG_replaceCharcterInRange:NSMakeRange(4, card_id.length - 8) withCharcter:@" **** **** "];
        self.card_id_Label.text = [NSString stringWithFormat:@"%@", card_id];
        
        // 银行预留手机号
        NSString *phone = dictionary[@"phone"];
        phone = [phone SG_replaceCharcterInRange:NSMakeRange(3, phone.length - 7) withCharcter:@" **** "];
        self.phone_Label.text = [NSString stringWithFormat:@"%@", phone];
        
        // 开始倒计时
//        [self startCountDown:_getVC_btn];
        [_getVC_btn start];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
        });
        SGDebugLog(@"error - - - %@", error);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快捷支付";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(touchView)];
    [self setupSubviews];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToTopVC) image:@"navigationButtonReturn" highImage:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShowNotification:(NSNotification *)notif{
    CGRect rect = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    self.bgScrollView.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0);
    self.bgScrollView.scrollIndicatorInsets = self.bgScrollView.contentInset;
    [self.bgScrollView scrollRectToVisible:self.payBtn.frame animated:NO];
    [UIView commitAnimations];
    
}

- (void)keyboardWillHideNotification:(NSNotification *)notif{
    self.bgScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.bgScrollView.scrollIndicatorInsets = self.bgScrollView.contentInset;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backToTopVC {
    if ([JCBSingletonManager sharedSingletonManager].isMBHTML5VCToRongBaoPayVC == YES) {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[JCBBingCardAuthenticationVC class]]) {
                JCBBingCardAuthenticationVC *bingCardAVC = (JCBBingCardAuthenticationVC *)VC;
                [self.navigationController popToViewController:bingCardAVC animated:YES];
            }
        }
        [JCBSingletonManager sharedSingletonManager].isMBHTML5VCToRongBaoPayVC = NO;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchView {
    [self.view endEditing:YES];
}

- (void)setupSubviews {
    self.bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - 64);
    _bgScrollView.backgroundColor = SGCommonBgColor;
    [self.view addSubview:_bgScrollView];
  
    UIView *oneView = [[UIView alloc] init];
    CGFloat oneViewX = 0;
    CGFloat oneViewY = SGMargin;
    CGFloat oneViewW = SG_screenWidth;
    CGFloat oneViewH = 89;
    oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
    oneView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:oneView];
    
    UILabel *payMoney = [[UILabel alloc] init];
    NSString *payMoneyStr = @"支付金额：";
    payMoney.text = payMoneyStr;
    CGSize payMoneySize = [SGHelperTool SG_sizeWithText:payMoneyStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(MAXFLOAT, oneViewH / 3)];
    CGFloat payMoneyW = payMoneySize.width;
    CGFloat payMoneyH = oneViewH / 3;
    CGFloat payMoneyX = SGMargin;
    CGFloat payMoneyY = 0;
    payMoney.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //payMoney.backgroundColor = SGColorWithRandom;
    payMoney.textAlignment = NSTextAlignmentLeft;
    payMoney.textColor = SGColorWithBlackOfDark;
    payMoney.frame = CGRectMake(payMoneyX, payMoneyY, payMoneyW, payMoneyH);
    [oneView addSubview:payMoney];
    
    self.payMoney_Label = [[UILabel alloc] init];
    CGFloat payMoney_LabelX = CGRectGetMaxX(payMoney.frame);
    CGFloat payMoney_LabelY = 0;
    CGFloat payMoney_LabelW = SG_screenWidth - payMoney_LabelX - SGMargin;
    CGFloat payMoney_LabelH = oneViewH / 3;
    _payMoney_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_payMoney_Label.backgroundColor = SGColorWithRandom;
    _payMoney_Label.textAlignment = NSTextAlignmentLeft;
    _payMoney_Label.textColor = SGColorWithRed;
    _payMoney_Label.frame = CGRectMake(payMoney_LabelX, payMoney_LabelY, payMoney_LabelW, payMoney_LabelH);
    [oneView addSubview:_payMoney_Label];
    
    UILabel *merchant_order_no = [[UILabel alloc] init];
    NSString *merchant_order_noStr = @"商户订单号：";
    merchant_order_no.text = merchant_order_noStr;
    CGSize merchant_order_noSize = [SGHelperTool SG_sizeWithText:merchant_order_noStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(MAXFLOAT, oneViewH / 3)];
    CGFloat merchant_order_noW = merchant_order_noSize.width;
    CGFloat merchant_order_noH = oneViewH / 3;
    CGFloat merchant_order_noX = SGMargin;
    CGFloat merchant_order_noY = CGRectGetMaxY(payMoney.frame);
    merchant_order_no.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //merchant_order_no.backgroundColor = SGColorWithRandom;
    merchant_order_no.textAlignment = NSTextAlignmentLeft;
    merchant_order_no.textColor = SGColorWithBlackOfDark;
    merchant_order_no.frame = CGRectMake(merchant_order_noX, merchant_order_noY, merchant_order_noW, merchant_order_noH);
    [oneView addSubview:merchant_order_no];
    
    self.merchant_order_no_Label = [[UILabel alloc] init];
    CGFloat merchant_order_no_LabelX = CGRectGetMaxX(merchant_order_no.frame);
    CGFloat merchant_order_no_LabelY = CGRectGetMaxY(_payMoney_Label.frame);
    CGFloat merchant_order_no_LabelW = SG_screenWidth - merchant_order_no_LabelX - SGMargin;
    CGFloat merchant_order_no_LabelH = oneViewH / 3;
    _merchant_order_no_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_payMoney_Label.backgroundColor = SGColorWithRandom;
    _merchant_order_no_Label.textAlignment = NSTextAlignmentLeft;
    _merchant_order_no_Label.textColor = SGColorWithBlackOfDark;
    _merchant_order_no_Label.frame = CGRectMake(merchant_order_no_LabelX, merchant_order_no_LabelY, merchant_order_no_LabelW, merchant_order_no_LabelH);
    [oneView addSubview:_merchant_order_no_Label];
    
    UILabel *payTime = [[UILabel alloc] init];
    NSString *payTimeStr = @"交易时间：";
    payTime.text = payTimeStr;
    CGSize payTimeSize = [SGHelperTool SG_sizeWithText:payTimeStr font:[UIFont systemFontOfSize:SGTextFontWith15] maxSize:CGSizeMake(MAXFLOAT, oneViewH / 3)];
    CGFloat payTimeW = payTimeSize.width;
    CGFloat payTimeH = oneViewH / 3;
    CGFloat payTimeX = SGMargin;
    CGFloat payTimeY = CGRectGetMaxY(merchant_order_no.frame);
    payTime.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //payTime.backgroundColor = SGColorWithRandom;
    payTime.textAlignment = NSTextAlignmentLeft;
    payTime.textColor = SGColorWithBlackOfDark;
    payTime.frame = CGRectMake(payTimeX, payTimeY, payTimeW, payTimeH);
    [oneView addSubview:payTime];
    
    self.payTime_Label = [[UILabel alloc] init];
    CGFloat payTime_LabelX = CGRectGetMaxX(payTime.frame);
    CGFloat payTime_LabelY = CGRectGetMaxY(_merchant_order_no_Label.frame);
    CGFloat payTime_LabelW = SG_screenWidth - payTime_LabelX - SGMargin;
    CGFloat payTime_LabelH = oneViewH / 3;
    _payTime_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_payMoney_Label.backgroundColor = SGColorWithRandom;
    _payTime_Label.textAlignment = NSTextAlignmentLeft;
    _payTime_Label.textColor = SGColorWithBlackOfDark;
    _payTime_Label.frame = CGRectMake(payTime_LabelX, payTime_LabelY, payTime_LabelW, payTime_LabelH);
    [oneView addSubview:_payTime_Label];
    
#pragma mark - - - twoView
    UIView *twoView = [[UIView alloc] init];
    CGFloat twoViewX = 0;
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + SGMargin;
    CGFloat twoViewW = SG_screenWidth;
    CGFloat twoViewH = 6 * SGMargin;
    twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
    twoView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:twoView];
    
    self.bank_Label = [[UILabel alloc] init];
    CGFloat bank_LabelX = SGMargin;
    CGFloat bank_LabelY = 0;
    CGFloat bank_LabelW = 0.5 * SG_screenWidth - SGMargin;
    CGFloat bank_LabelH = twoViewH;
    _bank_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_bank_Label.backgroundColor = SGColorWithRandom;
    _bank_Label.textAlignment = NSTextAlignmentLeft;
    _bank_Label.textColor = SGColorWithBlackOfDark;
    _bank_Label.frame = CGRectMake(bank_LabelX, bank_LabelY, bank_LabelW, bank_LabelH);
    [twoView addSubview:_bank_Label];
    
    self.bank_no_Label = [[UILabel alloc] init];
    CGFloat bank_no_LabelX = CGRectGetMaxX(_bank_Label.frame) + SGMargin;
    CGFloat bank_no_LabelY = 0;
    CGFloat bank_no_LabelW = 0.5 * SG_screenWidth - SGMargin;
    CGFloat bank_no_LabelH = twoViewH;
    _bank_no_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_bank_no_Label.backgroundColor = SGColorWithRandom;
    _bank_no_Label.textAlignment = NSTextAlignmentLeft;
    _bank_no_Label.textColor = SGColorWithBlackOfDark;
    _bank_no_Label.frame = CGRectMake(bank_no_LabelX, bank_no_LabelY, bank_no_LabelW, bank_no_LabelH);
    [twoView addSubview:_bank_no_Label];

    
#pragma mark - - - threeView - 持卡人
    UIView *threeView = [[UIView alloc] init];
    CGFloat threeViewX = 0;
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + SGMargin;
    CGFloat threeViewW = SG_screenWidth;
    CGFloat threeViewH = twoViewH;
    threeView.frame = CGRectMake(threeViewX, threeViewY, threeViewW, threeViewH);
    threeView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:threeView];
    
    UILabel *threeLeftLabel = [[UILabel alloc] init];
    CGFloat threeLeftLabelW = 130;
    CGFloat threeLeftLabelH = threeViewH;
    CGFloat threeLeftLabelX = SGMargin;
    CGFloat threeLeftLabelY = 0;
    threeLeftLabel.text = @"持卡人";
    //fiveLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //threeLeftLabel.backgroundColor = SGColorWithRandom;
    threeLeftLabel.textAlignment = NSTextAlignmentLeft;
    threeLeftLabel.frame = CGRectMake(threeLeftLabelX, threeLeftLabelY, threeLeftLabelW, threeLeftLabelH);
    [threeView addSubview:threeLeftLabel];

    self.name_Label = [[UILabel alloc] init];
    CGFloat name_LabelX = CGRectGetMaxX(threeLeftLabel.frame) + 2 * SGMargin;
    CGFloat name_LabelY = 0;
    CGFloat name_LabelW = SG_screenWidth - name_LabelX - SGMargin;
    CGFloat name_LabelH = threeViewH;
    _name_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_name_Label.backgroundColor = SGColorWithRandom;
    _name_Label.textAlignment = NSTextAlignmentLeft;
    _name_Label.textColor = SGColorWithBlackOfDark;
    _name_Label.frame = CGRectMake(name_LabelX, name_LabelY, name_LabelW, name_LabelH);
    [threeView addSubview:_name_Label];
    
#pragma mark - - - threeView - 身份证号
    UIView *fourView = [[UIView alloc] init];
    CGFloat fourViewX = 0;
    CGFloat fourViewY = CGRectGetMaxY(threeView.frame) + SGMargin;
    CGFloat fourViewW = SG_screenWidth;
    CGFloat fourViewH = threeViewH;
    fourView.frame = CGRectMake(fourViewX, fourViewY, fourViewW, fourViewH);
    fourView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:fourView];
    
    UILabel *fourLeftLabel = [[UILabel alloc] init];
    CGFloat fourLeftLabelW = 130;
    CGFloat fourLeftLabelH = fourViewH;
    CGFloat fourLeftLabelX = SGMargin;
    CGFloat fourLeftLabelY = 0;
    fourLeftLabel.text = @"身份证号";
    //fiveLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //fourLeftLabel.backgroundColor = SGColorWithRandom;
    fourLeftLabel.textAlignment = NSTextAlignmentLeft;
    fourLeftLabel.frame = CGRectMake(fourLeftLabelX, fourLeftLabelY, fourLeftLabelW, fourLeftLabelH);
    [fourView addSubview:fourLeftLabel];
    
    self.card_id_Label = [[UILabel alloc] init];
    CGFloat card_id_LabelX = CGRectGetMaxX(fourLeftLabel.frame) + 2 * SGMargin;
    CGFloat card_id_LabelY = 0;
    CGFloat card_id_LabelW = SG_screenWidth - card_id_LabelX - SGMargin;
    CGFloat card_id_LabelH = fourViewH;
    _card_id_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_phone_Label.backgroundColor = SGColorWithRandom;
    _card_id_Label.textAlignment = NSTextAlignmentLeft;
    _card_id_Label.textColor = SGColorWithBlackOfDark;
    _card_id_Label.frame = CGRectMake(card_id_LabelX, card_id_LabelY, card_id_LabelW, card_id_LabelH);
    [fourView addSubview:_card_id_Label];
    
#pragma mark - - - threeView - 银行预留手机号
    UIView *fiveView = [[UIView alloc] init];
    CGFloat fiveViewX = 0;
    CGFloat fiveViewY = CGRectGetMaxY(fourView.frame) + SGMargin;
    CGFloat fiveViewW = SG_screenWidth;
    CGFloat fiveViewH = twoViewH;
    fiveView.frame = CGRectMake(fiveViewX, fiveViewY, fiveViewW, fiveViewH);
    fiveView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:fiveView];
    
    UILabel *fiveLeftLabel = [[UILabel alloc] init];
    CGFloat fiveLeftLabelW = 130;
    CGFloat fiveLeftLabelH = fiveViewH;
    CGFloat fiveLeftLabelX = SGMargin;
    CGFloat fiveLeftLabelY = 0;
    fiveLeftLabel.text = @"银行预留手机号";
    //fiveLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    //fiveLeftLabel.backgroundColor = SGColorWithRandom;
    fiveLeftLabel.textAlignment = NSTextAlignmentLeft;
    fiveLeftLabel.frame = CGRectMake(fiveLeftLabelX, fiveLeftLabelY, fiveLeftLabelW, fiveLeftLabelH);
    [fiveView addSubview:fiveLeftLabel];
    
    self.phone_Label = [[UILabel alloc] init];
    CGFloat phone_LabelX = CGRectGetMaxX(fiveLeftLabel.frame) + 2 * SGMargin;
    CGFloat phone_LabelY = 0;
    CGFloat phone_LabelW = SG_screenWidth - phone_LabelX - SGMargin;
    CGFloat phone_LabelH = fiveViewH;
    _phone_Label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    //_phone_Label.backgroundColor = SGColorWithRandom;
    _phone_Label.textAlignment = NSTextAlignmentLeft;
    _phone_Label.textColor = SGColorWithBlackOfDark;
    _phone_Label.frame = CGRectMake(phone_LabelX, phone_LabelY, phone_LabelW, phone_LabelH);
    [fiveView addSubview:_phone_Label];
    
#pragma mark - - - threeView - 验证码
    UIView *sixView = [[UIView alloc] init];
    CGFloat sixViewX = 0;
    CGFloat sixViewY = CGRectGetMaxY(fiveView.frame) + SGMargin;
    CGFloat sixViewW = SG_screenWidth;
    CGFloat sixViewH = twoViewH;
    sixView.frame = CGRectMake(sixViewX, sixViewY, sixViewW, sixViewH);
    sixView.backgroundColor = SGColorWithWhite;
    [_bgScrollView addSubview:sixView];
    
    // 获取验证码按钮
    CGFloat getVC_btnW = 90;
    CGFloat getVC_btnH = 30;
    CGFloat getVC_btnX = SG_screenWidth - getVC_btnW - SGMargin;
    CGFloat getVC_btnY = 0.5 * (sixViewH - getVC_btnH);
    self.getVC_btn = [[STCountDownButton alloc]initWithFrame:CGRectMake(getVC_btnX, getVC_btnY, getVC_btnW, getVC_btnH)];
    _getVC_btn.backgroundColor = [UIColor redColor];
    _getVC_btn.layer.cornerRadius = 5;
    _getVC_btn.layer.masksToBounds = YES;
    _getVC_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getVC_btn setSecond:registerCountDownTime];
    [_getVC_btn addTarget:self action:@selector(startCountDown:)forControlEvents:UIControlEventTouchUpInside];
    [sixView addSubview:_getVC_btn];
    
    self.verification_code_TF = [[UITextField alloc] init];
    CGFloat verification_code_TFX = SGMargin;
    CGFloat verification_code_TFY = 0;
    CGFloat verification_code_TFW = SG_screenWidth - 3 * verification_code_TFX - getVC_btnW;
    CGFloat verification_code_TFH = sixViewH;
    _verification_code_TF.frame = CGRectMake(verification_code_TFX, verification_code_TFY, verification_code_TFW, verification_code_TFH);
    _verification_code_TF.delegate = self;
    //_verification_code_TF.backgroundColor = SGColorWithRandom;
    _verification_code_TF.placeholder = @"请输入验证码";
    _verification_code_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verification_code_TF.keyboardType = UIKeyboardTypeNumberPad;
    _verification_code_TF.tintColor = SGColorWithRed;
    [_verification_code_TF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [sixView addSubview:_verification_code_TF];
    
#pragma mark - - - threeView - 确认支付
    self.payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat payBtnX = SGMargin;
    CGFloat payBtnY = CGRectGetMaxY(sixView.frame) + 3 * SGMargin;
    CGFloat payBtnW = SG_screenWidth - 2 * payBtnX;
    CGFloat payBtnH = 5 * SGMargin;
    _payBtn.frame = CGRectMake(payBtnX, payBtnY, payBtnW, payBtnH);
    [_payBtn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    _payBtn.backgroundColor = SGCommonRedColor;
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [SGSmallTool SG_smallWithThisView:_payBtn cornerRadius:5];
    [_payBtn addTarget:self action:@selector(surePay_Btn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [_bgScrollView addSubview:_payBtn];
    
    
    CGFloat h = CGRectGetMaxY(_payBtn.frame) + 22;
    if (h > _bgScrollView.frame.size.height) {
        _bgScrollView.contentSize = CGSizeMake(SG_screenWidth, h);
    }else{
        _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width, _bgScrollView.frame.size.height);
    }
}

#pragma mark - - - 获取验证码按钮的点击事件
- (void)startCountDown:(STCountDownButton *)sender {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/ajaxGetPhoneCodeRongbao", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.user_order_no;
    
    [SGHttpTool postAll:urlStr params:params success:^(id json) {
        SGDebugLog(@"ajaxGetPhoneCodeRongbao - json - - - %@", json);
        if ([json[@"rcd"] isEqualToString:@"R0001"]) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"短信发送成功, 请稍等..." delayTime:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sender start];
            });
        } else if ([json[@"rcd"] isEqualToString:@"M0008_6"]){
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"您已频繁获取验证码，请5分钟后再次尝试" delayTime:1.0];
        }
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
}

#pragma mark - - - 确认支付的点击事件
- (void)surePay_Btn_action {
    SGDebugLog(@"surePay_Btn_action");
    if (self.verification_code_TF.text.length == 0) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入短信验证码" delayTime:1.0];
        
    } else { // 确认支付
        [MBProgressHUD SG_showMBProgressHUD10sHideWithModifyStyleMessage:@"订单正在提交中..." toView:self.navigationController.view];

        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/toPayRongbao", SGCommonURL];
        urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"orderNo"] = self.user_order_no;
        params[@"checkCode"] = self.verification_code_TF.text;

        [SGHttpTool postAll:urlStr params:params success:^(id json) {
            SGDebugLog(@"toPayRongbao - json - - - %@", json);

            if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                
                [self beginTimer];
            } else {
                [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", json[@"rmg"]] delayTime:1.5];
                });
            }
            
        } failure:^(NSError *error) {
            SGDebugLog(@"error - - - %@", error);
            [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

        }];
    }
}

#pragma mark - - - timer 
- (void)timer_action {
    self.totalSecond += 2;
    SGDebugLog(@"totalSecond - - - %ld", self.totalSecond);
    if (self.totalSecond == 8) {
        [self stopTimer];
        // 跳转界面
        [self pushNextVC];
    } else {
        [self getDataFromeNetWorking];
    }
    
}
// 开启定时器
- (void)beginTimer {
    // 创建定时器
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timer_action) userInfo:nil repeats:YES];
    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
// 停止定时器
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// 获取支付之后的结果
- (void)getDataFromeNetWorking {

    NSString *urlString = [NSString stringWithFormat:@"%@/rest/payResult", SGCommonURL];
    urlString = [urlString SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlString];
    NSMutableDictionary *paramsss = [NSMutableDictionary dictionary];
    paramsss[@"orderNo"] = self.user_order_no;
    [SGHttpTool postAll:urlString params:paramsss success:^(id json) {
        SGDebugLog(@"payResult - json - - - %@", json);
        self.pushTo_resultMoney = json[@"rmg"];
        if ([json[@"rcd"] isEqualToString:@"R0001"]) {
            [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

            [self stopTimer];
            // 跳转界面
            [self pushNextVC];
        }
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
        [self stopTimer];
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
    }];
}

- (void)pushNextVC {
    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 跳转界面
        JCBPayResultVC *payResultVC = [[JCBPayResultVC alloc] init];
        payResultVC.result_order_no = self.user_order_no;
        payResultVC.result_money = self.dataSource_dict[@"money"];
        payResultVC.result_payment = self.pushTo_resultMoney;
        [self.navigationController pushViewController:payResultVC animated:YES];
    });
}

#pragma mark - - - UITextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textField1TextChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.payBtn.backgroundColor = SGColorWithRGB(244, 145, 150);
    } else {
        self.payBtn.backgroundColor = SGColorWithRed;
    }
}




@end
