//
//  JCBWithdrawCashVC.m
//  JCBJCB
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBWithdrawCashVC.h"
#import "JCBPresentRecordVC.h"
#import "JCBTransactionPWSettingNextVC.h"
#import "JCBWithdrawCashModel.h"

@interface JCBWithdrawCashVC () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *useMoneyLabel;
@property (nonatomic, strong) UITextField *turnOutMoneyTF;
@property (nonatomic, strong) UITextField *changePWTF;
@property (nonatomic, strong) NSDictionary *dataSource_dict;
// 提现方式
@property (nonatomic, strong) UIView *threeView;
@property (nonatomic, strong) UILabel *paymentMethodLabel;
@property (nonatomic, strong) UIButton *withdrawMethodBtn;
@property (nonatomic, strong) UILabel *explainContentLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@end

@implementation JCBWithdrawCashVC

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
    [SGNotificationCenter addObserver:self selector:@selector(getDataSourceFromeNetWorking) name:@"cashGetDataSource" object:nil];
    
    [self setupSubviews];
}

- (void)dealloc {
    [SGNotificationCenter removeObserver:self];
}

/** view 手势 */
- (void)panGestureRecognizer_action {
    [self.view endEditing:YES];
}

/** 加载数据 */
- (void)getDataSourceFromeNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/cashTo", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"cashTo - dictionary - - - %@", dictionary);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        self.dataSource_dict = dictionary;
        if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) { // 用户已经绑卡呢
            // 先移除，后添加
            [_promptLabel removeFromSuperview];
            //[_withdrawMethodBtn removeFromSuperview];
            
            [_threeView addSubview:_paymentMethodLabel];
            [_threeView addSubview:_withdrawMethodBtn];
            
            JCBWithdrawCashModel *model = [JCBWithdrawCashModel mj_objectWithKeyValues:dictionary];
            // 可用余额
            self.useMoneyLabel.text = model.ableMoney;
            [self.withdrawMethodBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_bankCard_%@_icon", model.bankId]] forState:(UIControlStateNormal)];
            [self.withdrawMethodBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_bankCard_%@_icon", model.bankId]] forState:(UIControlStateHighlighted)];
            NSString *cardNoStr = [NSString stringWithFormat:@"%@", model.cardNo];
            NSString *lastFourCardNo = [cardNoStr substringFromIndex:cardNoStr.length - 4];
            [self.withdrawMethodBtn setTitle:[NSString stringWithFormat:@"%@(尾号为：%@)", model.bankName, lastFourCardNo] forState:(UIControlStateNormal)];
            
            // 显示余额提现说明
            _explainContentLabel.text = [NSString stringWithFormat:@"每月前%@笔提现免手续费，超过每笔收取%@元手续费，本月您已累计提现%@笔", dictionary[@"cashChargeTimes"], dictionary[@"feeFixed"], dictionary[@"userCashChargeTimes"]];

        } else { // 用户没有绑卡呢
            // 创建一个提示 label 提示用户绑卡
            [_promptLabel removeFromSuperview];
            [_paymentMethodLabel removeFromSuperview];
            [_withdrawMethodBtn removeFromSuperview];
            [self setupPromptLabel];
            
            self.useMoneyLabel.text = [NSString stringWithFormat:@"%.2f", [[JCBSingletonManager sharedSingletonManager].user_money floatValue]];
            // 显示余额提现说明
            _explainContentLabel.text = [NSString stringWithFormat:@"每月前5笔提现免手续费，超过每笔收取5元手续费，本月您已累计提现0笔"];
        }
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
            
#pragma mark - - - 数据请求失败
            // 创建一个提示 label 提示用户绑卡
            [_promptLabel removeFromSuperview];
            [self setupPromptLabel];
            
            self.useMoneyLabel.text = [NSString stringWithFormat:@"%@", [JCBSingletonManager sharedSingletonManager].user_money];
            // 显示余额提现说明
            _explainContentLabel.text = [NSString stringWithFormat:@"每月前5笔提现免手续费，超过每笔收取5元手续费，本月您已累计提现0笔"];
        });
    }];
}

- (void)setupPromptLabel {
    self.promptLabel = [[UILabel alloc] init];
    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = 0;
    CGFloat promptLabelW = SG_screenWidth;
    CGFloat promptLabelH = _threeView.SG_height;
    _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    _promptLabel.text = @"提现需绑定银行卡，完成首次充值后自动绑卡";
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    [SGSmallTool SG_smallWithThisLabel:_promptLabel frontText:@"提现需绑定银行卡，" behindText:@"完成首次充值后自动绑卡" behindTextColor:SGColorWithRed behindTextFont:SGTextFontWith13 centerLineBool:NO];

    [self.threeView addSubview:_promptLabel];
}

- (void)setupSubviews {
    UIScrollView *bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - navigationAndStatusBarHeight - 44 - 1);
    bgScrollView.backgroundColor = SGCommonBgColor;
    [self.view addSubview:bgScrollView];
    
    UIView *bgTopView = [[UIView alloc] init];
    CGFloat bgTopViewX = 0;
    CGFloat bgTopViewY = SGMargin;
    CGFloat bgTopViewW = SG_screenWidth;
    CGFloat bgTopViewH = bgScrollView.SG_height * 0.29;
    bgTopView.frame = CGRectMake(bgTopViewX, bgTopViewY, bgTopViewW, bgTopViewH);
    bgTopView.backgroundColor = SGColorWithWhite;
    [bgScrollView addSubview:bgTopView];
    
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
    
    UIButton *presentRecord = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat presentRecordX = CGRectGetMaxX(textLabel.frame);
    CGFloat presentRecordY = textLabelY;
    CGFloat presentRecordW = 72;
    CGFloat presentRecordH = textLabelH;
    //forgetBtn.backgroundColor = SGColorWithRandom;
    presentRecord.frame = CGRectMake(presentRecordX, presentRecordY, presentRecordW, presentRecordH);
    presentRecord.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    [presentRecord setTitle:@"提现记录" forState:(UIControlStateNormal)];
    [presentRecord setTitleColor:SGColorWithRed forState:(UIControlStateNormal)];
    [presentRecord addTarget:self action:@selector(presentRecordBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [SGSmallTool SG_smallWithThisView:presentRecord cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:presentRecord borderWidth:1 borderColor:SGColorWithRed];
    [bgTopView addSubview:presentRecord];
    
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
    UIView *oneView = [[UIView alloc] init];
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
    oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
    oneView.backgroundColor = SGColorWithWhite;
    [bgScrollView addSubview:oneView];
    
    UIImageView *oneImageView = [[UIImageView alloc] init];
    oneImageView.image = [UIImage imageNamed:@"mine_rechangeCash_money_icon"];
    CGFloat oneImageViewW = oneImageView.image.size.width;
    CGFloat oneImageViewH = oneImageView.image.size.height;
    CGFloat oneImageViewX = SGMargin;
    CGFloat oneImageViewY = (oneViewH - oneImageViewH) * 0.5;
    oneImageView.frame = CGRectMake(oneImageViewX, oneImageViewY, oneImageViewW, oneImageViewH);
    [oneView addSubview:oneImageView];
    
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
    [oneView addSubview:moneyLabel];

    self.turnOutMoneyTF = [[UITextField alloc] init];
    CGFloat turnOutMoneyTFH = 30;
    CGFloat turnOutMoneyTFX = CGRectGetMaxX(oneImageView.frame) + SGMargin;
    CGFloat turnOutMoneyTFY = (oneViewH - turnOutMoneyTFH) * 0.5;
    CGFloat turnOutMoneyTFW = SG_screenWidth - turnOutMoneyTFX - moneyLabelW - 2 * SGMargin;
    //_turnOutMoneyTF.backgroundColor = SGColorWithRandom;
    _turnOutMoneyTF.frame = CGRectMake(turnOutMoneyTFX, turnOutMoneyTFY, turnOutMoneyTFW, turnOutMoneyTFH);
    _turnOutMoneyTF.placeholder = @"请输入转出金额";
    _turnOutMoneyTF.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _turnOutMoneyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _turnOutMoneyTF.keyboardType = UIKeyboardTypeDefault;
    [oneView addSubview:_turnOutMoneyTF];
    
#pragma mark - - - twoView
    UIView *twoView = [[UIView alloc] init];
    CGFloat twoViewX = 0;
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + SGMargin;
    CGFloat twoViewW = SG_screenWidth;
    CGFloat twoViewH = oneViewH;
    twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
    twoView.backgroundColor = SGColorWithWhite;
    [bgScrollView addSubview:twoView];

    UIImageView *twoImageView = [[UIImageView alloc] init];
    twoImageView.image = [UIImage imageNamed:@"mine_rechangeCash_lock_icon"];
    CGFloat twoImageViewW = twoImageView.image.size.width;
    CGFloat twoImageViewH = twoImageView.image.size.height;
    CGFloat twoImageViewX = SGMargin;
    CGFloat twoImageViewY = (twoViewH - twoImageViewH) * 0.5;
    twoImageView.frame = CGRectMake(twoImageViewX, twoImageViewY, twoImageViewW, twoImageViewH);
    [twoView addSubview:twoImageView];
    
    self.changePWTF = [[UITextField alloc] init];
    CGFloat changePWTFH = turnOutMoneyTFH;
    CGFloat changePWTFX = CGRectGetMaxX(oneImageView.frame) + SGMargin;
    CGFloat changePWTFY = (twoViewH - changePWTFH) * 0.5;
    CGFloat changePWTFW = SG_screenWidth - changePWTFX - 2 * SGMargin;
    //_changePWTF.backgroundColor = SGColorWithRandom;
    _changePWTF.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _changePWTF.frame = CGRectMake(changePWTFX, changePWTFY, changePWTFW, changePWTFH);
    _changePWTF.placeholder = @"请输入交易密码";
    _changePWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _changePWTF.keyboardType = UIKeyboardTypeDefault;
    _changePWTF.secureTextEntry = YES;
    _changePWTF.delegate = self;
    [twoView addSubview:_changePWTF];
    
#pragma mark - - - 忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat forgetBtnW = 72;
    CGFloat forgetBtnH = 30;
    CGFloat forgetBtnX = SG_screenWidth - forgetBtnW;
    CGFloat forgetBtnY = CGRectGetMaxY(twoView.frame);
    //forgetBtn.backgroundColor = SGColorWithRandom;
    forgetBtn.frame = CGRectMake(forgetBtnX, forgetBtnY, forgetBtnW, forgetBtnH);
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    [forgetBtn setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
    [forgetBtn setTitleColor:SGColorWithBlackOfDark forState:(UIControlStateNormal)];
    [forgetBtn addTarget:self action:@selector(forgetBtn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [bgScrollView addSubview:forgetBtn];
    
#pragma mark - - - threeView - 提现至
    self.threeView = [[UIView alloc] init];
    CGFloat threeViewX = 0;
    CGFloat threeViewY = CGRectGetMaxY(forgetBtn.frame);
    CGFloat threeViewW = SG_screenWidth;
    CGFloat threeViewH = twoViewH;
    _threeView.frame = CGRectMake(threeViewX, threeViewY, threeViewW, threeViewH);
    _threeView.backgroundColor = SGColorWithWhite;
    [bgScrollView addSubview:_threeView];

    self.paymentMethodLabel = [[UILabel alloc] init];
    CGFloat paymentMethodLabelX = SGMargin;
    CGFloat paymentMethodLabelY = 0;
    CGFloat paymentMethodLabelW = 50;
    CGFloat paymentMethodLabelH = threeViewH;
    _paymentMethodLabel.text = @"提现至";
    //paymentMethodLabel.backgroundColor = SGColorWithRandom;
    _paymentMethodLabel.font = [UIFont boldSystemFontOfSize:SGTextFontWith15];
    _paymentMethodLabel.frame = CGRectMake(paymentMethodLabelX, paymentMethodLabelY, paymentMethodLabelW, paymentMethodLabelH);
    
    self.withdrawMethodBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat withdrawMethodBtnX = CGRectGetMaxX(_paymentMethodLabel.frame) + SGMargin;
    CGFloat withdrawMethodBtnY = 0;
    CGFloat withdrawMethodBtnW = 200;
    CGFloat withdrawMethodBtnH = threeViewH;
    _withdrawMethodBtn.frame = CGRectMake(withdrawMethodBtnX, withdrawMethodBtnY, withdrawMethodBtnW, withdrawMethodBtnH);
    //_paymentMethodBtn.backgroundColor = SGColorWithRandom;
    _withdrawMethodBtn.imageEdgeInsets = UIEdgeInsetsMake(0, - SGMargin, 0, 0);
    [_withdrawMethodBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _withdrawMethodBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    
#pragma mark - - - 确认按钮
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat sureBtnX = SGMargin;
    CGFloat sureBtnY = CGRectGetMaxY(_threeView.frame) + 2 * SGMargin;
    CGFloat sureBtnW = SG_screenWidth - 2 * sureBtnX;
    CGFloat sureBtnH = threeViewH;
    sureBtn.frame = CGRectMake(sureBtnX, sureBtnY, sureBtnW, sureBtnH);
    sureBtn.backgroundColor = SGColorWithRed;
    [sureBtn setTitle:@"确认提现" forState:(UIControlStateNormal)];
    //[sureBtn setTitleColor:SGColorWithBlackOfDark forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureBtn_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [SGSmallTool SG_smallWithThisView:sureBtn cornerRadius:5];
    [bgScrollView addSubview:sureBtn];

#pragma mark - - - 余额提现说明
    UILabel *explainLabel = [[UILabel alloc] init];
    CGFloat explainLabelX = SGMargin;
    CGFloat explainLabelY = CGRectGetMaxY(sureBtn.frame) + SGSmallMargin;
    CGFloat explainLabelW = 100;
    CGFloat explainLabelH = 30;
    explainLabel.text = @"余额提现说明:";
    explainLabel.font = [UIFont boldSystemFontOfSize:SGTextFontWith13];
    explainLabel.frame = CGRectMake(explainLabelX, explainLabelY, explainLabelW, explainLabelH);
    [bgScrollView addSubview:explainLabel];

    UIView *leftView = [[UIView alloc] init];
    CGFloat leftViewX = SGMargin;
    CGFloat leftViewY = CGRectGetMaxY(explainLabel.frame) + SGMargin;
    CGFloat leftViewW = 6;
    CGFloat leftViewH = leftViewW;
    leftView.frame = CGRectMake(leftViewX, leftViewY, leftViewW, leftViewH);
    leftView.backgroundColor = SGColorWithRed;
    [SGSmallTool SG_smallWithThisView:leftView cornerRadius:leftViewH * 0.5];
    [bgScrollView addSubview:leftView];
    
    self.explainContentLabel = [[UILabel alloc] init];
    CGFloat explainContentLabelX = 2 * SGMargin + SGSmallMargin;
    CGFloat explainContentLabelY = CGRectGetMaxY(explainLabel.frame) + SGSmallMargin;
    CGFloat explainContentLabelW = SG_screenWidth - 3 * SGMargin;
    // 显示余额提现说明
    _explainContentLabel.text = @"您每月前%@笔提现免手续费，从第%@笔开始，每笔收取%@元手续费，本月您已累计提现%@笔";
    CGSize size = [self sizeWithText:_explainContentLabel.text font:[UIFont systemFontOfSize:SGTextFontWith13] maxSize:CGSizeMake(explainContentLabelW, CGFLOAT_MAX)];
    CGFloat explainContentLabelH = size.height;
    //_explainContentLabel.backgroundColor = [UIColor orangeColor];
    _explainContentLabel.numberOfLines = 0;
    _explainContentLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    _explainContentLabel.textColor = SGColorWithBlackOfDark;
    _explainContentLabel.frame = CGRectMake(explainContentLabelX, explainContentLabelY, explainContentLabelW, explainContentLabelH);
    [bgScrollView addSubview:_explainContentLabel];
    
    bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_explainContentLabel.frame) + 6 * SGMargin);
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - - - 提现记录按钮的点击事件
- (void)presentRecordBtn_action {
    JCBPresentRecordVC *PRVC = [[JCBPresentRecordVC alloc] init];
    [self.navigationController pushViewController:PRVC animated:YES];
}

#pragma mark - - - 忘记密码按钮的点击事件
- (void)forgetBtn_action {
    JCBTransactionPWSettingNextVC *forgetPWVC = [[JCBTransactionPWSettingNextVC alloc] init];
    [self.navigationController pushViewController:forgetPWVC animated:YES];
}

#pragma mark - - - 确认提现按钮的点击事件
- (void)sureBtn_action:(UIButton *)button {
    
    if ([self.dataSource_dict[@"rcd"] isEqualToString:@"R0001"]) {
        if (self.turnOutMoneyTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入提现金额" delayTime:1.0];
        } else {
            if (self.changePWTF.text.length == 0) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入交易密码" delayTime:1.0];
            } else {
                // 禁止再次点击
                button.userInteractionEnabled = NO;
                
                [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/rest/cashSave?cashMoney=%@&safepwd=%@", SGCommonURL, self.turnOutMoneyTF.text, self.changePWTF.text];
                urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                
                [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    SGDebugLog(@"dictionary - - - %@", dictionary);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) {
                            // 可以再次点击
                            button.userInteractionEnabled = YES;
                            
                            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"提现申请提交成功" delayTime:1.5];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self getDataSourceFromeNetWorking];
                                self.turnOutMoneyTF.text = @"";
                                self.changePWTF.text = @"";
                            });
                        } else {
                            // 可以再次点击
                            button.userInteractionEnabled = YES;
                            
                            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", dictionary[@"rmg"]] delayTime:2.0];
                        }
                    });
                    
                } failure:^(NSError *error) {
                    // 可以再次点击
                    button.userInteractionEnabled = YES;
                    
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
                    });
                    SGDebugLog(@"error - - -  %@", error);
                }];
                
            }
        }

    }else{
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"绑定银行卡之后才能提现" delayTime:1.5];
    }
    
}


#pragma mark - - - UITextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


@end


