//
//  JCBBingCardAuthenticationVC.m
//  JCBJCB
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBBingCardAuthenticationVC.h"
#import "JCBBingCardDropDownMenuVC.h"
#import "JCBBaoFuPayModel.h"
#import <BaoFooPay/BaoFooPay.h>
#import "JCBRongBaoPayVC.h"
#import "JCBCMBHTML5VC.h"
#import "JCBBindCardSMSViewController.h"

@interface JCBBingCardAuthenticationVC () <RightDropDownMenuDelegate, JCBBingCardDropDownMenuVCDelegate, BaofooSdkDelegate, SGAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *IDTF;
@property (nonatomic, strong) UITextField *bankBranchTF;
@property (nonatomic, strong) UITextField *bankCardNumTF;
@property (nonatomic, strong) UITextField *transactionPWTF;
@property (nonatomic, strong) UITextField *reservePNTF; // 银行预留手机号
/** 分割线 */
@property (nonatomic, strong) UIView *splitView;
@property (nonatomic, strong) UIButton *chioseButton;
/** 展示选择的哪家银行 */
@property (nonatomic, strong) UIButton *showChioseBtnContent;
@property (nonatomic, strong) RightDropDownMenu *menu;
/** 交易密码显示的label */
@property (nonatomic, strong) UILabel *sixLabel;
@property (nonatomic, strong) NSDictionary *user_dataSource_dict;
@property (nonatomic, strong) NSString *cardNum_str;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankID;
@property (nonatomic, strong) UIView *bankcardNumView;
@property (nonatomic, strong) UILabel *bankcardNumLabel;

@end

@implementation JCBBingCardAuthenticationVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/bankTo", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"json - - - %@", json);

        
        if ([json[@"rcd"] isEqualToString:@"R0001"]) {
            self.user_dataSource_dict = json;
            
            if (![json[@"cardNo"] isKindOfClass:[NSNull class]]) {
                self.bankCardNumTF.text = json[@"cardNo"];
                self.cardNum_str = json[@"cardNo"];
                
                // 显示大的 银行卡号
                NSMutableString *string = [NSMutableString stringWithFormat:@"%@", json[@"cardNo"]];
                for (int i =0; i<[string length]; i++) {
                    if (i%5 == 0) {
                        [string insertString:@" "atIndex:i];
                    }
                }
                self.bankcardNumLabel.text = string;
            }
            
            if ([json[@"realName"] isEqual:@""] || [json[@"realName"] isKindOfClass:[NSNull class]]) {
                self.nameTF.text = @"";
                self.IDTF.text = @"";
                self.sixLabel.text = @"输入交易密码";
            } else {
                self.nameTF.text = json[@"realName"];
                self.IDTF.text = json[@"idNo"];
                self.sixLabel.text = @"设置交易密码";
            }
            
        }
        
    } failure:^(NSError *error) {
        SGDebugLog(@"json - - - %@", error);

    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑卡认证";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(fingerTapped:)];

    [self setupBGScrollView];

}

#pragma mark - - - 手势点击事件
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}


- (void)setupBGScrollView {
    self.bgScrollView = [[UIScrollView alloc] init];
    CGFloat bgScrollViewX = 0;
    CGFloat bgScrollViewY = 0;
    CGFloat bgScrollViewW = SG_screenWidth;
    CGFloat bgScrollViewH = SG_screenHeight;
    _bgScrollView.frame = CGRectMake(bgScrollViewX, bgScrollViewY, bgScrollViewW, bgScrollViewH - navigationAndStatusBarHeight);
    _bgScrollView.backgroundColor = SGCommonBgColor;
    [self.view addSubview:_bgScrollView];

#pragma mark - - - 请确保以下信息真实有效
    UILabel *top_label = [[UILabel alloc] init];
    CGFloat top_labelX = SGMargin;
    CGFloat top_labelY = 0;
    CGFloat top_labelW = SG_screenWidth - 2 * SGMargin;
    CGFloat top_labelH = 32;
    top_label.frame = CGRectMake(top_labelX, top_labelY, top_labelW, top_labelH);
    top_label.backgroundColor = [UIColor clearColor];
    top_label.text = @"请确保以下信息真实有效";
    top_label.textColor = SGColorWithBlackOfDark;
    top_label.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [self.bgScrollView addSubview:top_label];
    
#pragma mark - - - 第一个背景view
    UIView *one_view = [[UIView alloc] init];
    CGFloat one_viewX = 0;
    CGFloat one_viewY = CGRectGetMaxY(top_label.frame);
    CGFloat one_viewW = SG_screenWidth;
    CGFloat one_viewH;
    if (iphone5s) {
        one_viewH = 50;
    } else if (iphone6s) {
        one_viewH = 55;
    } else if (iphone6P) {
        one_viewH = 60;
    } else if (iphone4s) {
        one_viewH = 45;
    }
    one_view.frame = CGRectMake(one_viewX, one_viewY, one_viewW, one_viewH);
    one_view.backgroundColor = SGColorWithWhite;
    [self.bgScrollView addSubview:one_view];
  
    UILabel *oneLabel = [[UILabel alloc] init];
    CGFloat oneLabelX = SGMargin;
    CGFloat oneLabelY = 0;
    CGFloat oneLabelW = 35;
    CGFloat oneLabelH = one_viewH;
    oneLabel.frame = CGRectMake(oneLabelX, oneLabelY, oneLabelW, oneLabelH);
    oneLabel.backgroundColor = [UIColor clearColor];
    oneLabel.text = @"姓名";
    //oneLabel.backgroundColor = [UIColor brownColor];
    oneLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [one_view addSubview:oneLabel];
    
    self.nameTF = [[UITextField alloc] init];
    CGFloat nameTFX = CGRectGetMaxX(oneLabel.frame) + SGMargin;
    CGFloat nameTFW = SG_screenWidth - nameTFX - SGMargin;
    CGFloat nameTFH = 20;
    CGFloat nameTFY = (one_viewH - nameTFH) * 0.5;
    _nameTF.placeholder = @"请输入您的真实姓名";
    _nameTF.delegate = self;
    _nameTF.font = [UIFont systemFontOfSize:SGTextFontWith12];
    //_nameTF.backgroundColor = [UIColor yellowColor];
    _nameTF.frame = CGRectMake(nameTFX, nameTFY, nameTFW, nameTFH);
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTF.keyboardType = UIKeyboardTypeDefault;
    [one_view addSubview:_nameTF];
    
#pragma mark - - - 第二个背景view
    UIView *two_view = [[UIView alloc] init];
    CGFloat two_viewX = 0;
    CGFloat two_viewY = CGRectGetMaxY(one_view.frame) + SGMargin;
    CGFloat two_viewW = SG_screenWidth;
    CGFloat two_viewH = one_viewH;
    two_view.frame = CGRectMake(two_viewX, two_viewY, two_viewW, two_viewH);
    two_view.backgroundColor = SGColorWithWhite;
    [self.bgScrollView addSubview:two_view];

    UILabel *twoLabel = [[UILabel alloc] init];
    CGFloat twoLabelX = SGMargin;
    CGFloat twoLabelY = 0;
    CGFloat twoLabelW = 48;
    CGFloat twoLabelH = two_viewH;
    twoLabel.frame = CGRectMake(twoLabelX, twoLabelY, twoLabelW, twoLabelH);
    twoLabel.backgroundColor = [UIColor clearColor];
    twoLabel.text = @"身份证";
    //twoLabel.backgroundColor = [UIColor brownColor];
    twoLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [two_view addSubview:twoLabel];
    
    self.IDTF = [[UITextField alloc] init];
    CGFloat IDTFX = CGRectGetMaxX(twoLabel.frame) + SGMargin;
    CGFloat IDTFW = SG_screenWidth - IDTFX - SGMargin;
    CGFloat IDTFH = 20;
    CGFloat IDTFY = (two_viewH - IDTFH) * 0.5;
    _IDTF.placeholder = @"请输入您的身份证号码";
    //_IDTF.text = @"412726199208094976";
    _IDTF.font = [UIFont systemFontOfSize:SGTextFontWith12];
    //_IDTF.backgroundColor = [UIColor yellowColor];
    _IDTF.frame = CGRectMake(IDTFX, IDTFY, IDTFW, IDTFH);
    _IDTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _IDTF.keyboardType = UIKeyboardTypeDefault;
    [two_view addSubview:_IDTF];
    
#pragma mark - - - 第三个背景view
    UIView *three_view = [[UIView alloc] init];
    CGFloat three_viewX = 0;
    CGFloat three_viewY = CGRectGetMaxY(two_view.frame) + SGMargin;
    CGFloat three_viewW = SG_screenWidth;
    CGFloat three_viewH = one_viewH;
    three_view.frame = CGRectMake(three_viewX, three_viewY, three_viewW, three_viewH);
    three_view.backgroundColor = SGColorWithWhite;
    [self.bgScrollView addSubview:three_view];
   
    UILabel *threeLabel = [[UILabel alloc] init];
    CGFloat threeLabelX = SGMargin;
    CGFloat threeLabelY = 0;
    CGFloat threeLabelW = 78;
    CGFloat threeLabelH = three_viewH;
    threeLabel.frame = CGRectMake(threeLabelX, threeLabelY, threeLabelW, threeLabelH);
    threeLabel.backgroundColor = [UIColor clearColor];
    threeLabel.text = @"请选择银行";
    threeLabel.textColor = SGColorWithDarkGrey;
    //threeLabel.backgroundColor = [UIColor brownColor];
    threeLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [three_view addSubview:threeLabel];
    
    self.splitView = [[UIView alloc] init];
    CGFloat splitViewX = CGRectGetMaxX(threeLabel.frame) + SGSmallMargin;
    CGFloat splitViewY = SGMargin;
    CGFloat splitViewW = 1;
    CGFloat splitViewH = three_viewH - 2 * splitViewY;
    _splitView.frame = CGRectMake(splitViewX, splitViewY, splitViewW, splitViewH);
    _splitView.backgroundColor = SGColorWithDarkGrey;
    [three_view addSubview:_splitView];
    
    self.chioseButton = [[UIButton alloc] init];
    CGFloat chioseButtonW = 32;
    CGFloat chioseButtonH = 16;
    CGFloat chioseButtonX = SG_screenWidth - SGSmallMargin - chioseButtonW - SGSmallMargin;
    CGFloat chioseButtonY = (three_viewH - chioseButtonH) * 0.5;
    _chioseButton.frame = CGRectMake(chioseButtonX, chioseButtonY, chioseButtonW, chioseButtonH);
    //chioseButton.backgroundColor = [UIColor redColor];
    [_chioseButton setBackgroundImage:[UIImage imageNamed:@"mine_down_icon"] forState:(UIControlStateNormal)];
    [_chioseButton setBackgroundImage:[UIImage imageNamed:@"mine_top_icon"] forState:(UIControlStateSelected)];
    [_chioseButton addTarget:self action:@selector(chioseButton_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [three_view addSubview:_chioseButton];
    
    self.showChioseBtnContent = [[UIButton alloc] init];
    CGFloat showChioseBtnContentX = CGRectGetMaxX(_splitView.frame) + SGSmallMargin;
    CGFloat showChioseBtnContentY = 0;
    CGFloat showChioseBtnContentW = SG_screenWidth - showChioseBtnContentX - SGMargin - chioseButtonW - SGSmallMargin;
    CGFloat showChioseBtnContentH = three_viewH;
    _showChioseBtnContent.frame = CGRectMake(showChioseBtnContentX, showChioseBtnContentY, showChioseBtnContentW, showChioseBtnContentH);
    _showChioseBtnContent.imageEdgeInsets = UIEdgeInsetsMake(0, - 5 * SGMargin, 0, 0);
    _showChioseBtnContent.titleEdgeInsets = UIEdgeInsetsMake(0, - 3 * SGMargin, 0, 0);
    // _showChioseBtnContent.backgroundColor = [UIColor redColor];
    [three_view addSubview:_showChioseBtnContent];
    
#pragma mark - - - 第四个背景view
    UIView *four_view = [[UIView alloc] init];
    CGFloat four_viewX = 0;
    CGFloat four_viewY = CGRectGetMaxY(three_view.frame) + SGMargin;
    CGFloat four_viewW = SG_screenWidth;
    CGFloat four_viewH = one_viewH;
    four_view.frame = CGRectMake(four_viewX, four_viewY, four_viewW, four_viewH);
    four_view.backgroundColor = SGColorWithWhite;
    //[self.bgScrollView addSubview:four_view];
    
    self.bankBranchTF = [[UITextField alloc] init];
    CGFloat bankBranchTFX = SGMargin;
    CGFloat bankBranchTFW = SG_screenWidth - 2 * SGMargin;
    CGFloat bankBranchTFH = 20;
    CGFloat bankBranchTFY = (four_viewH - bankBranchTFH) * 0.5;
    _bankBranchTF.placeholder = @"请填写开户支行";
    _bankBranchTF.delegate = self;
    _bankBranchTF.keyboardType = UIKeyboardTypeDefault;
    _bankBranchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _bankBranchTF.font = [UIFont systemFontOfSize:SGTextFontWith12];
    // _bankBranchTF.backgroundColor = [UIColor yellowColor];
    _bankBranchTF.frame = CGRectMake(bankBranchTFX, bankBranchTFY, bankBranchTFW, bankBranchTFH);
    [four_view addSubview:_bankBranchTF];
    
#pragma mark - - - 第五个背景view
    UIView *five_view = [[UIView alloc] init];
    CGFloat five_viewX = 0;
    CGFloat five_viewY = CGRectGetMaxY(three_view.frame) + SGMargin;
    CGFloat five_viewW = SG_screenWidth;
    CGFloat five_viewH = one_viewH;
    five_view.frame = CGRectMake(five_viewX, five_viewY, five_viewW, five_viewH);
    five_view.backgroundColor = SGColorWithWhite;
    [self.bgScrollView addSubview:five_view];
    
    self.bankCardNumTF = [[UITextField alloc] init];
    CGFloat bankCardNumTFX = SGMargin;
    CGFloat bankCardNumTFW = SG_screenWidth - 2 * SGMargin;
    CGFloat bankCardNumTFH = 20;
    CGFloat bankCardNumTFY = (four_viewH - bankCardNumTFH) * 0.5;
    _bankCardNumTF.placeholder = @"请填写银行卡号";
    //_bankCardNumTF.text = @"6226622302931635";
    _bankCardNumTF.font = [UIFont systemFontOfSize:SGTextFontWith12];
    // _bankBranchTF.backgroundColor = [UIColor yellowColor];
    _bankCardNumTF.frame = CGRectMake(bankCardNumTFX, bankCardNumTFY, bankCardNumTFW, bankCardNumTFH);
    _bankCardNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _bankCardNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [_bankCardNumTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [five_view addSubview:_bankCardNumTF];
    // UIKeyboardTypeNumberPad UIKeyboardTypeDefault
    
#pragma mark - - - 银行卡号显大View
    self.bankcardNumView = [[UIView alloc] init];
    CGFloat bankcardNumViewX = 0;
    CGFloat bankcardNumViewY = CGRectGetMaxY(five_view.frame);
    CGFloat bankcardNumViewW = SG_screenWidth - 2 * bankcardNumViewX;
    CGFloat bankcardNumViewH = one_viewH;
    _bankcardNumView.frame = CGRectMake(bankcardNumViewX, bankcardNumViewY, bankcardNumViewW, bankcardNumViewH);
    _bankcardNumView.backgroundColor = SGColorWithRGB(254, 214, 121);
    [self.bgScrollView addSubview:_bankcardNumView];
    
    self.bankcardNumLabel = [[UILabel alloc] init];
    CGFloat bankcardNumLabelX = SGMargin;
    CGFloat bankcardNumLabelY = SGSmallMargin;
    CGFloat bankcardNumLabelW = SG_screenWidth - 2 * bankcardNumLabelX;
    CGFloat bankcardNumLabelH = bankcardNumViewH - 2 * bankcardNumLabelY;
    _bankcardNumLabel.frame = CGRectMake(bankcardNumLabelX, bankcardNumLabelY, bankcardNumLabelW, bankcardNumLabelH);
    _bankcardNumLabel.font = [UIFont systemFontOfSize:22];
    _bankcardNumLabel.textColor = SGColorWithRGB(214, 147, 34);
    //_bankcardNumLabel.backgroundColor = SGColorWithRed;
    [self.bankcardNumView addSubview:_bankcardNumLabel];
    
#pragma mark - - - 银行预留手机号 view
    UIView *reserve_view = [[UIView alloc] init];
    CGFloat reserve_viewX = 0;
    CGFloat reserve_viewY = CGRectGetMaxY(self.bankcardNumView.frame) + SGMargin;
    CGFloat reserve_viewW = SG_screenWidth;
    CGFloat reserve_viewH = one_viewH;
    reserve_view.frame = CGRectMake(reserve_viewX, reserve_viewY, reserve_viewW, reserve_viewH);
    reserve_view.backgroundColor = SGColorWithWhite;
    [self.bgScrollView addSubview:reserve_view];
    
    self.reservePNTF = [[UITextField alloc] init];
    CGFloat reservePNTFX = SGMargin;
    CGFloat reservePNTFW = SG_screenWidth - 2 * SGMargin;
    CGFloat reservePNTFH = 20;
    CGFloat reservePNTFY = (reserve_viewH - reservePNTFH) * 0.5;
    _reservePNTF.placeholder = @"请填写银行预留手机号码";
    //_bankCardNumTF.text = @"6226622302931635";
    _reservePNTF.font = [UIFont systemFontOfSize:SGTextFontWith12];
    // _bankBranchTF.backgroundColor = [UIColor yellowColor];
    _reservePNTF.frame = CGRectMake(reservePNTFX, reservePNTFY, reservePNTFW, reservePNTFH);
    _reservePNTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _reservePNTF.keyboardType = UIKeyboardTypeNumberPad;
    [reserve_view addSubview:_reservePNTF];
    
#pragma mark - - - 交易密码在用户投资和提现时使用
    UILabel *textLabel = [[UILabel alloc] init];
    CGFloat textLabelX = SGMargin;
    CGFloat textLabelY = CGRectGetMaxY(reserve_view.frame);
    CGFloat textLabelW = SG_screenWidth - 2 * textLabelX;
    CGFloat textLabelH = 35;
    textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    textLabel.text = @"交易密码在用户投资和提现时使用";
    textLabel.textColor = SGColorWithBlackOfDark;
    textLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [self.bgScrollView addSubview:textLabel];

#pragma mark - - - 第六个背景view
    UIView *six_view = [[UIView alloc] init];
    CGFloat six_viewX = 0;
    CGFloat six_viewY = CGRectGetMaxY(textLabel.frame);
    CGFloat six_viewW = SG_screenWidth;
    CGFloat six_viewH = one_viewH;
    six_view.frame = CGRectMake(six_viewX, six_viewY, six_viewW, six_viewH);
    six_view.backgroundColor = SGColorWithWhite;
    [self.bgScrollView addSubview:six_view];
 
    self.sixLabel = [[UILabel alloc] init];
    CGFloat sixLabelX = SGMargin;
    CGFloat sixLabelY = 0;
    CGFloat sixLabelW = 96;
    CGFloat sixLabelH = six_viewH;
    _sixLabel.frame = CGRectMake(sixLabelX, sixLabelY, sixLabelW, sixLabelH);
    _sixLabel.backgroundColor = [UIColor clearColor];
    //sixLabel.text = @"设置交易密码";
    //sixLabel.backgroundColor = [UIColor brownColor];
    _sixLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [six_view addSubview:_sixLabel];
   
    self.transactionPWTF = [[UITextField alloc] init];
    CGFloat transactionPWTFX = CGRectGetMaxX(_sixLabel.frame) + SGMargin;
    CGFloat transactionPWTFW = SG_screenWidth - transactionPWTFX - SGMargin;
    CGFloat transactionPWTFH = 20;
    CGFloat transactionPWTFY = (six_viewH - transactionPWTFH) * 0.5;
    _transactionPWTF.placeholder = @"至少6个字符";
    _transactionPWTF.font = [UIFont systemFontOfSize:SGTextFontWith12];
    //_transactionPWTF.backgroundColor = [UIColor whiteColor];
    _transactionPWTF.frame = CGRectMake(transactionPWTFX, transactionPWTFY, transactionPWTFW, transactionPWTFH);
    _transactionPWTF.secureTextEntry = YES;
    _transactionPWTF.delegate = self;
    _transactionPWTF.keyboardType = UIKeyboardTypeDefault;
    _transactionPWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [six_view addSubview:_transactionPWTF];
    
    UIButton *button = [[UIButton alloc] init];
    CGFloat buttonX = SGMargin;
    CGFloat buttonY = CGRectGetMaxY(six_view.frame) + SGMargin;
    CGFloat buttonW = SG_screenWidth - 2 * buttonX;
    CGFloat buttonH = six_viewH;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:@"前往认证" forState:(UIControlStateNormal)];
    button.backgroundColor = SGColorWithRed;
    [SGSmallTool SG_smallWithThisView:button cornerRadius:5];
    [button addTarget:self action:@selector(button_action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgScrollView addSubview:button];
    

#pragma mark - - - 目前支持：工商、农业、中国、建设、邮储、中信、平安、广大、交通、兴业、民生、浦发、上海、招商银行
    UILabel *bottomLabel = [[UILabel alloc] init];
    CGFloat bottomLabelX = SGMargin;
    CGFloat bottomLabelY = CGRectGetMaxY(button.frame) + SGMargin;
    CGFloat bottomLabelW = SG_screenWidth - 2 * textLabelX;
    bottomLabel.text = @"目前支持：工商、农业、中国、建设、邮储、中信、平安、广大、交通、兴业、民生、浦发、上海银行、招商银行";
    bottomLabel.numberOfLines = 0;
    bottomLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    CGSize bottomLabelSize = [self sizeWithText:bottomLabel.text font:[UIFont systemFontOfSize:SGTextFontWith14] maxSize:CGSizeMake(bottomLabelW, MAXFLOAT)];
    // CGFloat bottomLabelH = 35;
    bottomLabel.textColor = SGColorWithBlackOfDark;
    bottomLabel.frame = CGRectMake(bottomLabelX, bottomLabelY, bottomLabelW, bottomLabelSize.height);
    [self.bgScrollView addSubview:bottomLabel];
    
#pragma mark - - - 底部view
    UIView *bottomView = [[UIView alloc] init];
    CGFloat bottomViewX = 2 * SGMargin;
    CGFloat bottomViewY = CGRectGetMaxY(bottomLabel.frame) + SGMargin;
    CGFloat bottomViewW = SG_screenWidth - 2 * bottomViewX;
    CGFloat bottomViewH = SG_screenHeight * 0.2;
    bottomView.frame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    bottomView.backgroundColor = SGColorWithRGB(254, 237, 197);
    [SGSmallTool SG_smallWithThisView:bottomView cornerRadius:5];

    //[self.bgScrollView addSubview:bottomView];
    
    UIButton *reminderButton = [[UIButton alloc] init];
    CGFloat reminderButtonX = SGMargin;
    CGFloat reminderButtonY = SGMargin;
    CGFloat reminderButtonW = 100;
    CGFloat reminderButtonH = 20;
    reminderButton.frame = CGRectMake(reminderButtonX, reminderButtonY, reminderButtonW, reminderButtonH);
    // reminderButton.backgroundColor = SGColorWithRed;
    [reminderButton setTitle:@"温馨提示" forState:(UIControlStateNormal)];
    reminderButton.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    [reminderButton setTitleColor:SGColorWithRed forState:(UIControlStateNormal)];
    [reminderButton setImage:[UIImage imageNamed:@"mine_reminder_icon"] forState:(UIControlStateNormal)];
    reminderButton.imageEdgeInsets = UIEdgeInsetsMake(0, - (2 * SGMargin + SGSmallMargin), 0, 0);
    reminderButton.titleEdgeInsets = UIEdgeInsetsMake(0, - SGMargin, 0, 0);
    [bottomView addSubview:reminderButton];

#pragma mark - - - 为了保证您的账户安全，将会对您的银行卡进行扣款验证，扣款金额为 3.0 元
    UILabel *lastLabel = [[UILabel alloc] init];
    CGFloat lastLabelX = SGMargin;
    CGFloat lastLabelY = CGRectGetMaxY(reminderButton.frame) + SGMargin;
    CGFloat lastLabelW = bottomViewW - 2 * lastLabelX;
    lastLabel.text = @"为了保证您的账户安全，将会对您的银行卡进行扣款验证，招商银行扣款金额为 3.0 元，其他银行扣款金额为 0.1 元";
    lastLabel.numberOfLines = 0;
    lastLabel.font = [UIFont systemFontOfSize:SGTextFontWith14];
    CGSize lastLabelSize = [self sizeWithText:lastLabel.text font:[UIFont systemFontOfSize:SGTextFontWith14] maxSize:CGSizeMake(lastLabelW, MAXFLOAT)];
    // CGFloat bottomLabelH = 35;
    lastLabel.frame = CGRectMake(lastLabelX, lastLabelY, lastLabelW, lastLabelSize.height);
    lastLabel.textColor = SGColorWithBlackOfDark;
    [bottomView addSubview:lastLabel];
    
    self.bgScrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(bottomView.frame) + 2 * SGMargin);
}


#pragma mark - - - 选择银行卡类型按钮的点击事件
- (void)chioseButton_action:(UIButton *)button {
    if (button.selected == YES) {
        
    } else {
        
        self.menu = [RightDropDownMenu menu];
        _menu.delegate = self;
        
        // 2.设置内容
        JCBBingCardDropDownMenuVC *vc = [[JCBBingCardDropDownMenuVC alloc] init];
        vc.view.SG_height = SG_screenHeight * 0.37;
        vc.view.SG_width = SG_screenWidth - CGRectGetMaxX(self.splitView.frame) - SGSmallMargin;
        _menu.contentController = vc;
        vc.delegate_dropDown = self;
        
        // 3.显示
        [_menu showFrom:button];
    }
}

#pragma mark - - - RightDropDownMenu 代理方法
- (void)dropdownMenuDidDismiss:(RightDropDownMenu *)menu {
    _chioseButton.selected = NO;
}

- (void)dropdownMenuDidShow:(RightDropDownMenu *)menu {
    _chioseButton.selected = YES;
}

#pragma mark - - - JCBBingCardDropDownMenuVC 代理方法
- (void)dismiss {
    [self.menu dismiss];
}

- (void)JCBBingCardDropDownMenuVC:(JCBBingCardDropDownMenuVC *)JCBBingCardDropDownMenuVC imageName:(UIImage *)imageName title:(NSString *)title bankId:(NSString *)bankId {
    [self.showChioseBtnContent setImage:imageName forState:(UIControlStateNormal)];
    [self.showChioseBtnContent setTitle:title forState:(UIControlStateNormal)];
    [self.showChioseBtnContent setTitleColor:SGColorWithDarkGrey forState:(UIControlStateNormal)];
    
    self.bankName = title;
    self.bankID = bankId;
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

#pragma mark - - - 前往认证的点击事件
- (void)button_action {
//    JCBBindCardSMSViewController *bvc = [[JCBBindCardSMSViewController alloc] init];
//    bvc.phoneNo = self.reservePNTF.text;
//    [self.navigationController pushViewController:bvc animated:YES];
//    return;

    if (self.nameTF.text.length == 0) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入您的名字" delayTime:1.0];
    } else {
        if (self.IDTF.text.length == 0) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入您的身份证号码" delayTime:1.0];
        } else if (self.IDTF.text.length != 18) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"您输入的身份证号码格式不正确" delayTime:1.0];
        } else if ([self.IDTF.text SG_isIdentityCard]) {

            if (self.bankID.length == 0) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请选择银行类型" delayTime:1.0];
            } else {
                
                if (self.bankCardNumTF.text.length == 0) {
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入您的银行卡号" delayTime:1.0];

                } else {
                    
                    if (self.transactionPWTF.text.length == 0) {
                        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入您的交易密码" delayTime:1.0];
                    } else {
                        
                        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"信息正在提交中..." toView:self.navigationController.view];
                        
                        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/bankSignSaveHnew", SGCommonURL];
                        urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                        
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        
                        NSString *string = nil;
                        if (self.cardNum_str.length != 0) {
                            string = @"1";
                        } else {
                            string = @"0";
                        }
                        SGDebugLog(@"bankCardNumTF - - - %@", self.bankCardNumTF.text);
                        params[@"btype"] = string;
                        params[@"cashBank.cardNo"] = self.bankCardNumTF.text;
                        params[@"cashBank.bankName"] = self.bankName;
                        params[@"money"] = self.bingCardMoney;
                        params[@"bankId"] = self.bankID;
                        params[@"realName"] = self.nameTF.text;
                        params[@"idNo"] = self.IDTF.text;
                        params[@"registerTime"] = self.user_dataSource_dict[@"registerTime"];
                        params[@"cardNo"] = self.bankCardNumTF.text;
                        params[@"safepwd"] = self.transactionPWTF.text;
                        params[@"phone"] = self.reservePNTF.text;
                        
                        [SGHttpTool postAll:urlStr params:params success:^(id json) {
                            SGDebugLog(@"json - - - %@", json);
                            [MBProgressHUD SG_hideHUDForView:self.navigationController.view];

                            if ([json[@"rcd"] isEqualToString:@"R0001"]) { // 数据提交正确
                                
                                //TODO:绑卡
//                                提交成功后服务端返回json rcd:R0001,就打开新界面,该界面需要用户填银行发送到手机的验证码,还有可一分钟后点击重复短信的按钮,再提交按钮.
//                                提交的url: /res/bankSignPhoneCode?token=对应的token&checkCode=输入值
//                                重发短信的url:/rest/bankSignPhoneCodeRepeat?token=对应的token
                                
                                JCBBindCardSMSViewController *bvc = [[JCBBindCardSMSViewController alloc] init];
                                bvc.phoneNo = self.reservePNTF.text;
                                [self.navigationController pushViewController:bvc animated:YES];
                                
                                // 屏蔽原来的支付
//                                JCBRongBaoPayVC *rongBaoVC = [[JCBRongBaoPayVC alloc] init];
//                                rongBaoVC.user_order_no = json[@"order_no"];
//                                [self.navigationController pushViewController:rongBaoVC animated:YES];

                            }else if ([json[@"rcd"] isEqualToString:@"R0002"]) {
                                
                                // 解决招商银行的 HTML5 界面充值
                                NSString *urlStr_two = [NSString stringWithFormat:@"%@/rest/verifycmb?rmg=%@&order_no=%@", SGCommonURL, json[@"rmg"], json[@"order_no"]];
                                urlStr_two = [urlStr_two SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr_two];
                                
                                JCBCMBHTML5VC *CMBHTML5VC = [[JCBCMBHTML5VC alloc] init];
                                CMBHTML5VC.url_Str = urlStr_two;
                                [self.navigationController pushViewController:CMBHTML5VC animated:YES];
                                
                            }else {
                                SGAlertView *alertV = [SGAlertView alertViewWithTitle:@"提示" delegate:nil contentTitle:[NSString stringWithFormat:@"%@", json[@"rmg"]] alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
                                [alertV show];
                            }
                            
                        } failure:^(NSError *error) {
                            SGDebugLog(@"error - - - %@", error);
                            [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
                            
                        }];

                        
                    }
                    
                
                }
                
            }
            
        }

    }
    
}

#pragma mark - - - UITextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textField1TextChange:(UITextField *)textField {
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@", textField.text];
    for (int i =0; i<[string length]; i++) {
        if (i % 5 == 0) {
            [string insertString:@" "atIndex:i];
        }
    }
    self.bankcardNumLabel.text = string;
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


