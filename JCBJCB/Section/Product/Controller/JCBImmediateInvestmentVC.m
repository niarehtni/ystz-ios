//
//  JCBImmediateInvestmentVC.m
//  JCBJCB
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBImmediateInvestmentVC.h"
#import "JCBTransactionPWSettingNextVC.h"
#import "JCBLoginRegisterVC.h"
#import "JCBProductRedVC.h"
#import "JCBProductInvestModel.h"
#import "JCBUserCenterModel.h"
#import "JCBProductRedModel.h"
#import <BaoFooPay/BaoFooPay.h>
#import "JCBBaoFuPayModel.h"
#import "JCBInvestmentSuccessVC.h"
#import "JCBBingCardAuthenticationVC.h"
#import "JCBRongBaoPayVC.h"

@interface JCBImmediateInvestmentVC () <UITextFieldDelegate, SGAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (strong, nonatomic) UILabel *topLeftLabel;
@property (strong, nonatomic) UILabel *topCenterLabel;
@property (strong, nonatomic) UILabel *topRightLabel;
@property (strong, nonatomic) UITextField *investmentAmountTF;
@property (strong, nonatomic) UIButton *showRedButton; // 显示红包金钱数按钮
@property (strong, nonatomic) UITextField *changePWTF; //
@property (strong, nonatomic) UILabel *canUserMeoey_label; // 可用余额
@property (strong, nonatomic) UIView *threeView;
@property (strong, nonatomic) UIView *fourView; // fourView
@property (strong, nonatomic) UIButton *forget_btn; // 忘记密码按钮
@property (strong, nonatomic) UIButton *immediateInvestBtn; // 立即投资按钮
@property (nonatomic, strong) NSMutableArray *bonus_arr;
@property (nonatomic, strong) JCBProductInvestModel *investModel;
@property (nonatomic, strong) NSDictionary *dataSource_dict_userCenter;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, strong) NSArray *red_arr;
@property (nonatomic, strong) NSMutableArray *useRed_mArr;

/** 还需充值的金钱数 */
@property (nonatomic, copy) NSString *haveRechargeMoney;
/** 投标名称 */
@property (nonatomic, copy) NSString *investmentName;
/** 选中红包的ID */
@property (nonatomic, copy) NSString *selectedRedId;
/** 限购金额 */
@property (nonatomic, copy) NSString *mostAccount;
@property (nonatomic, strong) NSDictionary *isBindCard_dic;

@end

@implementation JCBImmediateInvestmentVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"userCenter - dictionary - - - %@", dictionary);
        self.dataSource_dict_userCenter = dictionary;
        JCBUserCenterModel *model = [JCBUserCenterModel mj_objectWithKeyValues:dictionary];
        /** 可用余额 */
        NSString *string = [NSString stringWithFormat:@"%@", model.ableMoney];
        if ([string isEqualToString:@"<null>"]) {
            self.canUserMeoey_label.text = @"0元";
        } else {
            self.canUserMeoey_label.text = [NSString stringWithFormat:@"%.2f元", [model.ableMoney floatValue]];
        }
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
        
    }];
    
    // 判断用户是否邦卡
    [self getDataWithUserIsBindCard];
}

- (void)getDataWithUserIsBindCard {
    NSString *rechargeToUrlStr = [NSString stringWithFormat:@"%@/rest/rechargeTo", SGCommonURL];
    rechargeToUrlStr = [rechargeToUrlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:rechargeToUrlStr];
    
    [SGHttpTool getAll:rechargeToUrlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"rechargeTo - dictionary - - - %@", dictionary);
        self.isBindCard_dic = dictionary;
        
        if ([dictionary[@"rcd"] isEqualToString:@"M00010"]) { // 用户未绑卡
            _immediateInvestBtn.SG_y = CGRectGetMaxY(self.threeView.frame) + 5 * SGMargin;
            [_bgScrollView addSubview:_immediateInvestBtn];
            _bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_immediateInvestBtn.frame) + 20 * SGMargin);
        } else { // 用户已绑卡
            [_bgScrollView addSubview:_fourView];
            [_bgScrollView addSubview:_forget_btn];
            _immediateInvestBtn.SG_y = CGRectGetMaxY(self.fourView.frame) + 5 * SGMargin;
            [_bgScrollView addSubview:_immediateInvestBtn];
            _bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_immediateInvestBtn.frame) + 20 * SGMargin);
        }
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投资确认";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self foundSubviews];
    
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(tapGestureRecognizer_action)];

    // 注册观察者
    [SGNotificationCenter addObserver:self selector:@selector(getDataWithUserIsBindCard) name:@"ImmediateInvestmentGetDataSource" object:nil];
    
    // 获取从上个界面传过来的值
    [self getDataFromNetWorkingLastVC];
}

- (void)dealloc {
    [SGNotificationCenter removeObserver:self];
}

- (void)tapGestureRecognizer_action {
    [self.view endEditing:YES];
    self.view.transform = CGAffineTransformIdentity;
}

/** 获取从上个界面传来的数据 */
- (void)getDataFromNetWorkingLastVC {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrow/%@", SGCommonURL, self.valueID];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"borrow - json - - - %@", json);
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        self.investModel = [JCBProductInvestModel mj_objectWithKeyValues:json];
        SGDebugLog(@"mostAccount - 限购金额 - - - %@", json[@"mostAccount"]);
        self.mostAccount = json[@"mostAccount"];
        [self setupSubviews];
        
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        
        SGDebugLog(@"%@", error);
    }];
}

- (void)setupSubviews {
    [SGSmallTool SG_smallWithThisView:self.immediateInvestBtn cornerRadius:5];
    self.investmentAmountTF.tintColor = SGColorWithRed;
    self.changePWTF.tintColor = SGColorWithRed;
    
    [self.investmentAmountTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.investmentAmountTF.keyboardType = UIKeyboardTypeNumberPad;
    self.investmentAmountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.changePWTF.keyboardType = UIKeyboardTypeDefault;
    self.changePWTF.secureTextEntry = YES;
    self.changePWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 赋值
    self.idStr = self.investModel.ID;
    // 投标名称
    self.investmentName = self.investModel.name;
    
    self.topLeftLabel.text = [NSString stringWithFormat:@"%.2f%%", self.investModel.yearApr];
    self.topCenterLabel.text = [NSString stringWithFormat:@"%@元", self.investModel.balance];
    self.topRightLabel.text = [NSString stringWithFormat:@"%@天", self.investModel.timeLimit];
}

- (void)foundSubviews {
    self.bgScrollView = [[UIScrollView alloc] init];
    _bgScrollView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight);
    _bgScrollView.backgroundColor = SGCommonBgColor;
    [self.view addSubview:_bgScrollView];
    
    UIView *topBGView = [[UIView alloc] init];
    CGFloat topBGViewX = 0;
    CGFloat topBGViewY = 0;
    CGFloat topBGViewW = SG_screenWidth;
    CGFloat topBGViewH = SG_screenHeight * 0.15;
    topBGView.backgroundColor = SGCommonRedColor;
    topBGView.frame = CGRectMake(topBGViewX, topBGViewY, topBGViewW, topBGViewH);
    [_bgScrollView addSubview:topBGView];
    
    UIView *topView = [[UIView alloc] init];
    CGFloat topViewX = 0;
    CGFloat topViewY = 2 * SGMargin;
    CGFloat topViewW = SG_screenWidth;
    CGFloat topViewH = topBGViewH - 2 * topViewY;
    //topView.backgroundColor = [UIColor orangeColor];
    topView.frame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    [topBGView addSubview:topView];
    
    self.topLeftLabel = [[UILabel alloc] init];
    CGFloat topLeftLabelX = 0;
    CGFloat topLeftLabelY = 0;
    CGFloat topLeftLabelW = SG_screenWidth / 3 - 1;
    CGFloat topLeftLabelH = 0.5 * topViewH;
    _topLeftLabel.frame = CGRectMake(topLeftLabelX, topLeftLabelY, topLeftLabelW, topLeftLabelH);
    //_topLeftLabel.backgroundColor = SGColorWithRandom;
    _topLeftLabel.textColor = SGColorWithWhite;
    _topLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _topLeftLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_topLeftLabel];
    
    UILabel *bottomLeftLabel = [[UILabel alloc] init];
    CGFloat bottomLeftLabelX = 0;
    CGFloat bottomLeftLabelY = CGRectGetMaxY(_topLeftLabel.frame);
    CGFloat bottomLeftLabelW = topLeftLabelW;
    CGFloat bottomLeftLabelH = 0.5 * topViewH;
    bottomLeftLabel.frame = CGRectMake(bottomLeftLabelX, bottomLeftLabelY, bottomLeftLabelW, bottomLeftLabelH);
    //bottomLeftLabel.backgroundColor = SGColorWithRandom;
    bottomLeftLabel.text = @"预期年化收益率";
    bottomLeftLabel.textColor = SGColorWithWhite;
    bottomLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    bottomLeftLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:bottomLeftLabel];
    
    // 左边分割线
    UIView *left_line = [[UIView alloc] init];
    CGFloat left_lineX = CGRectGetMaxX(_topLeftLabel.frame);
    CGFloat left_lineY = SGSmallMargin;
    CGFloat left_lineW = 1;
    CGFloat left_lineH = topViewH - 2 * left_lineY;
    left_line.backgroundColor = SGColorWithWhite;
    left_line.frame = CGRectMake(left_lineX, left_lineY, left_lineW, left_lineH);
    [topView addSubview:left_line];
    
    self.topCenterLabel = [[UILabel alloc] init];
    CGFloat topCenterLabelX = CGRectGetMaxX(left_line.frame);
    CGFloat topCenterLabelY = 0;
    CGFloat topCenterLabelW = SG_screenWidth / 3;
    CGFloat topCenterLabelH = 0.5 * topViewH;
    _topCenterLabel.frame = CGRectMake(topCenterLabelX, topCenterLabelY, topCenterLabelW, topCenterLabelH);
    //_topCenterLabel.backgroundColor = SGColorWithRandom;
    _topCenterLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _topCenterLabel.textColor = SGColorWithWhite;
    _topCenterLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_topCenterLabel];
    
    UILabel *bottomCenterLabel = [[UILabel alloc] init];
    CGFloat bottomCenterLabelX = topCenterLabelX;
    CGFloat bottomCenterLabelY = CGRectGetMaxY(_topCenterLabel.frame);
    CGFloat bottomCenterLabelW = topCenterLabelW;
    CGFloat bottomCenterLabelH = 0.5 * topViewH;
    bottomCenterLabel.frame = CGRectMake(bottomCenterLabelX, bottomCenterLabelY, bottomCenterLabelW, bottomCenterLabelH);
    //bottomCenterLabel.backgroundColor = SGColorWithRandom;
    bottomCenterLabel.text = @"剩余可投金额(元)";
    bottomCenterLabel.textColor = SGColorWithWhite;
    bottomCenterLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    bottomCenterLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:bottomCenterLabel];
    
    // 右边边分割线
    UIView *right_line = [[UIView alloc] init];
    CGFloat right_lineX = CGRectGetMaxX(_topCenterLabel.frame);
    CGFloat right_lineY = SGSmallMargin;
    CGFloat right_lineW = 1;
    CGFloat right_lineH = topViewH - 2 * left_lineY;
    right_line.backgroundColor = SGColorWithWhite;
    right_line.frame = CGRectMake(right_lineX, right_lineY, right_lineW, right_lineH);
    [topView addSubview:right_line];
    
    self.topRightLabel = [[UILabel alloc] init];
    CGFloat topRightLabelX = CGRectGetMaxX(right_line.frame);
    CGFloat topRightLabelY = 0;
    CGFloat topRightLabelW = SG_screenWidth / 3 - right_lineW;
    CGFloat topRightLabelH = 0.5 * topViewH;
    _topRightLabel.frame = CGRectMake(topRightLabelX, topRightLabelY, topRightLabelW, topRightLabelH);
    //_topRightLabel.backgroundColor = SGColorWithRandom;
    _topRightLabel.textColor = SGColorWithWhite;
    _topRightLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _topRightLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_topRightLabel];
    
    UILabel *bottomRightLabel = [[UILabel alloc] init];
    CGFloat bottomRightLabelX = topRightLabelX;
    CGFloat bottomRightLabelY = CGRectGetMaxY(_topRightLabel.frame);
    CGFloat bottomRightLabelW = topCenterLabelW;
    CGFloat bottomRightLabelH = 0.5 * topViewH;
    bottomRightLabel.frame = CGRectMake(bottomRightLabelX, bottomRightLabelY, bottomRightLabelW, bottomRightLabelH);
    //bottomCenterLabel.backgroundColor = SGColorWithRandom;
    bottomRightLabel.text = @"项目期限(天)";
    bottomRightLabel.textColor = SGColorWithWhite;
    bottomRightLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    bottomRightLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:bottomRightLabel];
    
    
#pragma mark - - - oneView - 起投金额
    UIView *oneView = [[UIView alloc] init];
    CGFloat oneViewX = 0;
    CGFloat oneViewY = CGRectGetMaxY(topBGView.frame) + SGMargin;
    CGFloat oneViewW = SG_screenWidth;
    CGFloat oneViewH = SG_screenHeight * 0.1;
    oneView.backgroundColor = SGColorWithWhite;
    oneView.frame = CGRectMake(oneViewX, oneViewY, oneViewW, oneViewH);
    [_bgScrollView addSubview:oneView];

    // 100元起投
    UILabel *oneViewRightLabel = [[UILabel alloc] init];
    CGFloat oneViewRightLabelY = 0;
    CGFloat oneViewRightLabelW = 62;
    CGFloat oneViewRightLabelH = oneViewH;
    CGFloat oneViewRightLabelX = SG_screenWidth - oneViewRightLabelW - SGMargin;
    oneViewRightLabel.frame = CGRectMake(oneViewRightLabelX, oneViewRightLabelY, oneViewRightLabelW, oneViewRightLabelH);
    //oneViewRightLabel.backgroundColor = SGColorWithRandom;
    oneViewRightLabel.text = @"100元起投";
    oneViewRightLabel.textColor = SGColorWithBlackOfDark;
    oneViewRightLabel.font = [UIFont systemFontOfSize:SGTextFontWith13];
    oneViewRightLabel.textAlignment = NSTextAlignmentCenter;
    [oneView addSubview:oneViewRightLabel];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    CGFloat leftImageViewX = SGMargin;
    CGFloat leftImageViewW = 32;
    CGFloat leftImageViewH = 3 * SGMargin;
    CGFloat leftImageViewY = 0.5 * (oneViewH - leftImageViewH);
    leftImageView.frame = CGRectMake(leftImageViewX, leftImageViewY, leftImageViewW, leftImageViewH);
    leftImageView.image = [UIImage imageNamed:@"mine_rechangeCash_money_icon"];
    [oneView addSubview:leftImageView];
    
    self.investmentAmountTF = [[UITextField alloc] init];
    CGFloat investmentAmountTFH = 30;
    CGFloat investmentAmountTFX = CGRectGetMaxX(leftImageView.frame) + SGMargin;
    CGFloat investmentAmountTFY = 0.5 * (oneViewH - investmentAmountTFH);
    CGFloat investmentAmountTFW = SG_screenWidth - investmentAmountTFX - 2 * SGMargin - oneViewRightLabelW;
    _investmentAmountTF.frame = CGRectMake(investmentAmountTFX, investmentAmountTFY, investmentAmountTFW, investmentAmountTFH);
    //_investmentAmountTF.backgroundColor = SGColorWithRandom;
    _investmentAmountTF.placeholder = @"请输入投资金额";
    _investmentAmountTF.delegate = self;
    _investmentAmountTF.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [oneView addSubview:_investmentAmountTF];
    
#pragma mark - - - oneView - 红包抵扣现金
    UILabel *hongBaoLabel = [[UILabel alloc] init];
    CGFloat hongBaoLabelX = SGMargin;
    CGFloat hongBaoLabelY = CGRectGetMaxY(oneView.frame);
    CGFloat hongBaoLabelW = SG_screenWidth - hongBaoLabelX;
    CGFloat hongBaoLabelH = 2 * SGMargin;
    hongBaoLabel.frame = CGRectMake(hongBaoLabelX, hongBaoLabelY, hongBaoLabelW, hongBaoLabelH);
    hongBaoLabel.backgroundColor = SGColorWithClear;
    hongBaoLabel.text = @"红包抵扣现金";
    hongBaoLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    [_bgScrollView addSubview:hongBaoLabel];
    
#pragma mark - - - twoView - 使用红包
    UIView *twoView = [[UIView alloc] init];
    CGFloat twoViewX = 0;
    CGFloat twoViewY = CGRectGetMaxY(hongBaoLabel.frame);
    CGFloat twoViewW = SG_screenWidth;
    CGFloat twoViewH = oneViewH;
    twoView.backgroundColor = SGColorWithWhite;
    twoView.frame = CGRectMake(twoViewX, twoViewY, twoViewW, twoViewH);
    [_bgScrollView addSubview:twoView];
    
    // 使用红包
    UILabel *twoLeftLabel = [[UILabel alloc] init];
    CGFloat twoLeftLabelX = SGMargin;
    CGFloat twoLeftLabelY = 0;
    CGFloat twoLeftLabelW = 70;
    CGFloat twoLeftLabelH = twoViewH;
    twoLeftLabel.frame = CGRectMake(twoLeftLabelX, twoLeftLabelY, twoLeftLabelW, twoLeftLabelH);
    //twoLeftLabel.backgroundColor = SGColorWithRandom;
    twoLeftLabel.text = @"使用红包";
    twoLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith16];
    [twoView addSubview:twoLeftLabel];
    
    UIImageView *twoRightImageView = [[UIImageView alloc] init];
    CGFloat twoRightImageViewW = SGMargin;
    CGFloat twoRightImageViewH = 2 * SGMargin;
    CGFloat twoRightImageViewX = SG_screenWidth - SGMargin - twoRightImageViewW;
    CGFloat twoRightImageViewY = 0.5 * (twoViewH - twoRightImageViewH);
    twoRightImageView.frame = CGRectMake(twoRightImageViewX, twoRightImageViewY, twoRightImageViewW, twoRightImageViewH);
    twoRightImageView.image = [UIImage imageNamed:@"jcb_more"];
    [twoView addSubview:twoRightImageView];
    
    //
    self.showRedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat showRedButtonY = 0;
    CGFloat showRedButtonW = 100;
    CGFloat showRedButtonH = twoViewH;
    CGFloat showRedButtonX = SG_screenWidth - showRedButtonW - twoRightImageViewW - SGMargin - SGSmallMargin;
    _showRedButton.frame = CGRectMake(showRedButtonX, showRedButtonY, showRedButtonW, showRedButtonH);
    _showRedButton.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [_showRedButton setTitle:@"0.00" forState:(UIControlStateNormal)];
    //_showRedButton.backgroundColor = SGColorWithRed;
    [_showRedButton setTitleColor:SGColorWithRed forState:(UIControlStateNormal)];
    _showRedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_showRedButton addTarget:self action:@selector(showRedButton_action) forControlEvents:(UIControlEventTouchUpInside)];
    [twoView addSubview:_showRedButton];
    
#pragma mark - - - threeView - 剩余金额
    self.threeView = [[UIView alloc] init];
    CGFloat threeViewX = 0;
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + SGMargin;
    CGFloat threeViewW = SG_screenWidth;
    CGFloat threeViewH = oneViewH;
    _threeView.backgroundColor = SGColorWithWhite;
    _threeView.frame = CGRectMake(threeViewX, threeViewY, threeViewW, threeViewH);
    [_bgScrollView addSubview:_threeView];

    // 可用余额
    UILabel *threeLeftLabel = [[UILabel alloc] init];
    CGFloat threeLeftLabelX = SGMargin;
    CGFloat threeLeftLabelY = 0;
    CGFloat threeLeftLabelW = 70;
    CGFloat threeLeftLabelH = threeViewH;
    threeLeftLabel.frame = CGRectMake(threeLeftLabelX, threeLeftLabelY, threeLeftLabelW, threeLeftLabelH);
    //threeLeftLabel.backgroundColor = SGColorWithRandom;
    threeLeftLabel.text = @"可用余额";
    threeLeftLabel.font = [UIFont systemFontOfSize:SGTextFontWith16];
    [_threeView addSubview:threeLeftLabel];
    
    self.canUserMeoey_label = [[UILabel alloc] init];
    CGFloat canUserMeoey_labelX = CGRectGetMaxX(threeLeftLabel.frame) + SGMargin;
    CGFloat canUserMeoey_labelY = 0;
    CGFloat canUserMeoey_labelW = SG_screenWidth - canUserMeoey_labelX - SGMargin;
    CGFloat canUserMeoey_labelH = threeViewH;
    _canUserMeoey_label.frame = CGRectMake(canUserMeoey_labelX, canUserMeoey_labelY, canUserMeoey_labelW, canUserMeoey_labelH);
    //_canUserMeoey_label.backgroundColor = SGColorWithRandom;
    _canUserMeoey_label.text = @"0.00元";
    _canUserMeoey_label.textAlignment = NSTextAlignmentRight;
    _canUserMeoey_label.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [_threeView addSubview:_canUserMeoey_label];
    
#pragma mark - - - threeView - 输入交易密码
    self.fourView = [[UIView alloc] init];
    CGFloat fourViewX = 0;
    CGFloat fourViewY = CGRectGetMaxY(_threeView.frame) + SGMargin;
    CGFloat fourViewW = SG_screenWidth;
    CGFloat fourViewH = oneViewH;
    _fourView.backgroundColor = SGColorWithWhite;
    _fourView.frame = CGRectMake(fourViewX, fourViewY, fourViewW, fourViewH);
    
    UIImageView *fourViewleftImageView = [[UIImageView alloc] init];
    CGFloat fourViewleftImageViewX = SGMargin;
    CGFloat fourViewleftImageViewW = 2 * SGMargin + SGSmallMargin;
    CGFloat fourViewleftImageViewH = 3 * SGMargin + SGSmallMargin;
    CGFloat fourViewleftImageViewY = 0.5 * (oneViewH - leftImageViewH);
    fourViewleftImageView.frame = CGRectMake(fourViewleftImageViewX, fourViewleftImageViewY, fourViewleftImageViewW, fourViewleftImageViewH);
    fourViewleftImageView.image = [UIImage imageNamed:@"product_change_pw_icon"];
    [_fourView addSubview:fourViewleftImageView];
    
    // 请输入交易密码
    self.changePWTF = [[UITextField alloc] init];
    CGFloat changePWTFH = 30;
    CGFloat changePWTFX = CGRectGetMaxX(fourViewleftImageView.frame) + SGMargin;
    CGFloat changePWTFY = 0.5 * (oneViewH - changePWTFH);
    CGFloat changePWTFW = SG_screenWidth - changePWTFX - SGMargin;
    _changePWTF.frame = CGRectMake(changePWTFX, changePWTFY, changePWTFW, changePWTFH);
    //_changePWTF.backgroundColor = SGColorWithRandom;
    _changePWTF.placeholder = @"请输入交易密码";
    _changePWTF.delegate = self;
    _changePWTF.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [_fourView addSubview:_changePWTF];
    
#pragma mark - - - 忘记密码
    self.forget_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat forget_btnW = 8 * SGMargin;
    CGFloat forget_btnH = 5 * SGMargin;
    CGFloat forget_btnX = SG_screenWidth - forget_btnW;
    CGFloat forget_btnY = CGRectGetMaxY(_fourView.frame);
    _forget_btn.frame = CGRectMake(forget_btnX, forget_btnY, forget_btnW, forget_btnH);
    _forget_btn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [_forget_btn setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
    [_forget_btn setTitleColor:SGColorWithBlackOfDark forState:(UIControlStateNormal)];
    _forget_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forget_btn addTarget:self action:@selector(forgetPWButton_action:) forControlEvents:(UIControlEventTouchUpInside)];
    //_forget_btn.backgroundColor = SGColorWithRandom;

#pragma mark - - - 立即投资
    self.immediateInvestBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat immediateInvestBtnX = SGMargin;
    CGFloat immediateInvestBtnY = CGRectGetMaxY(_fourView.frame) + 5 * SGMargin;
    CGFloat immediateInvestBtnW = SG_screenWidth - 2 * immediateInvestBtnX;
    CGFloat immediateInvestBtnH = 5 * SGMargin;
    _immediateInvestBtn.frame = CGRectMake(immediateInvestBtnX, immediateInvestBtnY, immediateInvestBtnW, immediateInvestBtnH);
    _immediateInvestBtn.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [_immediateInvestBtn setTitle:@"立即投资" forState:(UIControlStateNormal)];
    _immediateInvestBtn.backgroundColor = SGCommonRedColor;
    _immediateInvestBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [SGSmallTool SG_smallWithThisView:_immediateInvestBtn cornerRadius:5];
    [_immediateInvestBtn addTarget:self action:@selector(immediateInvestment_action:) forControlEvents:(UIControlEventTouchUpInside)];

}

#pragma mark - - - 忘记密码点击事件
- (void)forgetPWButton_action:(UIButton *)sender {
    JCBTransactionPWSettingNextVC *TPWSetting = [[JCBTransactionPWSettingNextVC alloc] init];
    [self.navigationController pushViewController:TPWSetting animated:YES];
}

#pragma mark - - - 立即投资点击事件
- (void)immediateInvestment_action:(UIButton *)sender {
    if ([self.isBindCard_dic[@"rcd"] isEqualToString:@"M00010"]) { // 用户未绑卡
        if (self.investmentAmountTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入您要投资的金额" delayTime:1.5];
            
        } else if ([self.investmentAmountTF.text integerValue] < 100) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"起投金额不得少于100元" delayTime:1.5];
            
        } else{
            // 记录从立即投资界面跳转的
            [JCBSingletonManager sharedSingletonManager].isSureInvestment = YES;
            
            JCBBingCardAuthenticationVC *BCAVC = [[JCBBingCardAuthenticationVC alloc] init];
            BCAVC.bingCardMoney = self.investmentAmountTF.text;
            [self.navigationController pushViewController:BCAVC animated:YES];
        }

    } else {
        if (self.investmentAmountTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入您要投资的金额" delayTime:1.5];
            
        } else if ([self.investmentAmountTF.text floatValue] < 100) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"起投金额不得少于100元" delayTime:1.5];
            
        } else if ([self.investmentAmountTF.text integerValue] % 100 != 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"起投金额必须为100元的整数倍" delayTime:1.5];
            
        } else if ([self.investmentAmountTF.text floatValue] > [self.topCenterLabel.text floatValue]) {
            //[SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"您投资的金额已超过剩余可投金额" delayTime:1.0];
            self.investmentAmountTF.text = [NSString stringWithFormat:@"%@", self.investModel.balance];
            SGAlertView *alertView = [SGAlertView alertViewWithTitle:nil delegate:nil contentTitle:@"您投资的金额已超过剩余可投金额, 已自动为您转为剩余可投金额" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
            [alertView show];
        } else if (![self.mostAccount isEqualToString:@""] && [self.investmentAmountTF.text floatValue] > [self.mostAccount floatValue]) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"您投资的金额已超出限购金额" delayTime:1.5];
        
        /*
        } else if ([self.investmentAmountTF.text floatValue] > 50000) {
            SGAlertView *alertV = [SGAlertView alertViewWithTitle:@"提示" contentTitle:@"该商户本次可支付50000元，请更换其他银行卡或咨询商户客服" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne) didSelectedBtnIndex:^(SGAlertView *alertView, NSInteger index) {
                
            }];
            [alertV show];
         */
            
        } else {
            
            if (self.changePWTF.text.length == 0) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入交易密码" delayTime:1.0];
                
            } else {
                [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/rest/investDoH/%@", SGCommonURL, self.investModel.ID];
                //urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:userAccessToken];
                params[@"tenderMoney"] = self.investmentAmountTF.text;
                params[@"safepwd"] = self.changePWTF.text;
                params[@"clientType"] = @"2";
                params[@"hongbaoArray"] = self.selectedRedId;
                
                SGDebugLog(@"selectedRedId - - - %@", self.selectedRedId);
                
                [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
                    SGDebugLog(@"investDoH - dictionary - - - %@", dictionary);
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    // 需要增加的投资金额
                    self.haveRechargeMoney = [NSString stringWithFormat:@"%.2f", [self.investmentAmountTF.text floatValue] - [self.dataSource_dict_userCenter[@"ableMoney"] floatValue] - [self.showRedButton.titleLabel.text floatValue]];
                    
                    if ([self.haveRechargeMoney floatValue] > 0) { // 投资金额大于账户余额
                        //self.haveRechargeMoney = [NSString stringWithFormat:@"%.2f", [self.investmentAmountTF.text floatValue] - [self.dataSource_dict_userCenter[@"ableMoney"] floatValue] - [self.showRedButton.titleLabel.text floatValue]];
                        if ([self.haveRechargeMoney integerValue] < 3) {
                            self.haveRechargeMoney = [NSString stringWithFormat:@"%d", 3];
                            SGAlertView *alertView = [SGAlertView alertViewWithTitle:nil delegate:self contentTitle:[NSString stringWithFormat:@"您账户余额不足, 最少充值金额为%@元", self.haveRechargeMoney] alertViewBottomViewType:(SGAlertViewBottomViewTypeTwo)];
                            alertView.sure_btnTitleColor = SGColorWithRGB(98, 124, 255);
                            alertView.sure_btnTitle = @"立即充值";
                            [alertView show];
                        } else {
                            SGAlertView *alertView = [SGAlertView alertViewWithTitle:nil delegate:self contentTitle:[NSString stringWithFormat:@"您账户余额不足, 还需充值%@元", self.haveRechargeMoney] alertViewBottomViewType:(SGAlertViewBottomViewTypeTwo)];
                            alertView.sure_btnTitleColor = SGColorWithRGB(98, 124, 255);
                            alertView.sure_btnTitle = @"立即充值";
                            [alertView show];
                        }
                        
                    } else if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) { // 投资成功进行界面跳转
                        //[SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"投资成功" delayTime:1.0];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            JCBInvestmentSuccessVC *successVC = [[JCBInvestmentSuccessVC alloc] init];
                            successVC.projectName = self.investmentName;
                            successVC.investmentmoney = self.investmentAmountTF.text;
                            [self.navigationController pushViewController:successVC animated:YES];
                            
                        });
                    } else { // 投资失败
                        
                        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"提示" contentTitle:[NSString stringWithFormat:@"%@", dictionary[@"rmg"]] alertViewBottomViewType:(SGAlertViewBottomViewTypeOne) didSelectedBtnIndex:^(SGAlertView *alertView, NSInteger index) {
                            if (index == 0) {
                                
                            } else {
                                // 重新刷新上个界面的数据
                                [self getDataFromNetWorkingLastVC];
                            }
                        }];
                        [alertView show];
                    }
                    
                } failure:^(NSError *error) {
                    SGDebugLog(@"error - - - %@", error);
                    [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                    
                }];
                
            }
            
        }

    }
    
    
}



#pragma mark - - - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SGDebugLog(@" - - - - ");
    if (textField == self.changePWTF) {
        if (iphone5s) {
            self.view.transform = CGAffineTransformIdentity;
        }
    }
    if (iphone5s) {
        if (textField == self.changePWTF) {
            self.view.transform = CGAffineTransformMakeTranslation(0, - 0.15 * SG_screenHeight);
        }
    }
    return YES;
}
- (void)textField1TextChange:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([textField.text floatValue] < 100) {
            [self.showRedButton setTitle:[NSString stringWithFormat:@"0元"] forState:(UIControlStateNormal)];
        } else {
            [self getDataFromNetWorking]; // 获取最佳红包数
        }
    });
}

// 获取最佳红包数
- (void)getDataFromNetWorking {
    
    self.useRed_mArr = [@[] mutableCopy];
    [self.useRed_mArr removeAllObjects];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/hbListBestH", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"investFullMomeyMax"] = self.investmentAmountTF.text;
    params[@"borrowId"] = self.idStr;
    
    [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
        // SGDebugLog(@"dictionary - - - %@", dictionary);
        [self.showRedButton setTitle:[NSString stringWithFormat:@"%.f元", [dictionary[@"bestHbMoney"] floatValue]] forState:(UIControlStateNormal)];
        NSString *rangeStr = dictionary[@"bestNum"];
        NSMutableArray *tempArr = [JCBProductRedModel mj_objectArrayWithKeyValuesArray:dictionary[@"userHongbaoList"]];
        self.red_arr = [tempArr subarrayWithRange:NSMakeRange(0, [rangeStr integerValue])];
        
        for (int i = 0; i < self.red_arr.count; i++) {
            JCBProductRedModel *model = self.red_arr[i];
            [self.useRed_mArr addObject:model.ID];
        }
        
        self.selectedRedId = [self.useRed_mArr componentsJoinedByString:@","];
        
    } failure:^(NSError *error) {
        // SGDebugLog(@"%@", error);
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.showRedButton setTitle:[NSString stringWithFormat:@"0元"] forState:(UIControlStateNormal)];
    return YES;
}

#pragma mark - - - 选择红包的点击事件
- (void)showRedButton_action {
    if ([self.investmentAmountTF.text floatValue] >= 100) {
        JCBProductRedVC *redVC = [[JCBProductRedVC alloc] init];
        redVC.bidMoneyStr = self.investmentAmountTF.text;
        redVC.bidIDStr = self.idStr;
        redVC.surplus_money = self.investModel.balance;
        
        redVC.valueStr = ^(NSString *str) {
            [self.showRedButton setTitle:[NSString stringWithFormat:@"%@", str] forState:(UIControlStateNormal)];
        };
        
        redVC.valueArr = ^(NSString *redIDStr) {
            NSString *stringOfRedId = redIDStr;
            self.selectedRedId = stringOfRedId;
        };
        
        redVC.newMoney = ^(NSString *newM) {
            self.investmentAmountTF.text = newM;
        };
        
        [self.navigationController pushViewController:redVC animated:YES];
    } else {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"起投金额不得少于100元" delayTime:1.5];
    }
}

#pragma mark - - - SGAlertViewDelegate (余额不足，跳转宝付界面进行充值)
- (void)didSelectedLeftButtonClick {
    
}

- (void)didSelectedRightButtonClick {
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/rechargeSaveHnew", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userAccountRecharge.money"] = self.haveRechargeMoney;
    params[@"realName"] = self.isBindCard_dic[@"realName"];
    params[@"idNo"] = self.isBindCard_dic[@"cardId"];
    params[@"cardNo"] = self.isBindCard_dic[@"cardNo"];
    params[@"safepwd"] = self.changePWTF.text;
    params[@"registerTime"] = self.isBindCard_dic[@"registerTime"];
    
    [SGHttpTool postAll:urlStr params:params success:^(id dictionary) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"dictionary - - - %@", dictionary);
        if ([dictionary[@"rcd"] isEqualToString:@"S0002"]) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:dictionary[@"rmg"] delayTime:1.0];
        } else if ([dictionary[@"rcd"] isEqualToString:@"R0001"]) {
            // 记录从立即投资界面跳转的
            [JCBSingletonManager sharedSingletonManager].isSureInvestment = YES;
            
            JCBRongBaoPayVC *rongBaoVC = [[JCBRongBaoPayVC alloc] init];
            rongBaoVC.user_order_no = dictionary[@"order_no"];
            [self.navigationController pushViewController:rongBaoVC animated:YES];
                
        } else {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:dictionary[@"rmg"] delayTime:1.0];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"error - - -  %@", error);
    }];

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




@end



