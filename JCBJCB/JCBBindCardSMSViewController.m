//
//  JCBBandCardSMSViewController.m
//  yueshangdai
//
//  Created by 黄浚 on 2017/9/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBBindCardSMSViewController.h"

@interface JCBBindCardSMSViewController ()
@property (nonatomic, strong) JCBLabelView *phoneNoView;
@property (nonatomic, strong) JCBLabelView *verifyCodeView;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;;
@end

@implementation JCBBindCardSMSViewController

- (void)startTimer {
    self.time = 60;
    self.queue = dispatch_queue_create("cn.yueshanggroup.yueshangapp.timer", DISPATCH_QUEUE_SERIAL);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.time --;
            NSLog(@"%@:%ld",self.timer,(long)self.time);
            if (self.time == 0) {
                dispatch_source_cancel(self.timer);
                self.verifyCodeView.button.enabled = YES;
                [self.verifyCodeView.button setTitle:@"重新发送" forState:UIControlStateNormal];
            }else{
                self.verifyCodeView.button.enabled = NO;
                [self.verifyCodeView.button setTitle:[NSString stringWithFormat:@"剩余%ld秒",(long)self.time] forState:UIControlStateNormal];
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"输入验证码";
    self.view.backgroundColor = SGCommonBgColor;
    
    self.phoneNoView = [JCBLabelView labelViewWithWithName:@"手机号"];
    self.phoneNoView.frame = CGRectOffset(self.phoneNoView.frame, 0, SGMargin);
    self.phoneNoView.textField.text = self.phoneNo;
    self.phoneNoView.textField.enabled = NO;
    [self.view addSubview:self.phoneNoView];

    self.verifyCodeView = [JCBLabelView labelViewWithWithName:@"验证码"];
    self.verifyCodeView.frame = CGRectMake(self.verifyCodeView.frame.origin.x, CGRectGetMaxY(self.phoneNoView.frame) + SGMargin, self.verifyCodeView.frame.size.width, self.verifyCodeView.frame.size.height);
    self.verifyCodeView.textField.placeholder = @"请输入验证码";
    [self.verifyCodeView.button setTitle:@"60" forState:UIControlStateNormal];

    [self.verifyCodeView.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
    }];
    [self.verifyCodeView.button setBackgroundImageWithColor:SGColorWithRed forState:UIControlStateNormal];
    [self.verifyCodeView.button setBackgroundImageWithColor:SGColorWithDarkGrey forState:UIControlStateDisabled];
    self.verifyCodeView.button.enabled = NO;
    [self.verifyCodeView.button addTarget:self action:@selector(reSendverifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verifyCodeView];
    
    UIButton *button = [[UIButton alloc] init];
    CGFloat buttonW = SG_screenWidth - 2 * SGMargin;
    CGFloat buttonH = 50;
    button.frame = CGRectMake(SGMargin, CGRectGetMaxY(self.verifyCodeView.frame) + SGMargin, buttonW, buttonH);
    [button setTitle:@"下一步" forState:(UIControlStateNormal)];
    [button setBackgroundImageWithColor:SGColorWithRed forState:UIControlStateNormal];
    [SGSmallTool SG_smallWithThisView:button cornerRadius:5];
    [button addTarget:self action:@selector(button_action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    [self startTimer];
    
//    [self sendVerifyCode];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    dispatch_source_cancel(self.timer);
}



//提交的url: /rest/bankSignPhoneCode?token=对应的token&checkCode=输入值
//重发短信的url:/rest/bankSignPhoneCodeRepeat?token=对应的token

- (void)sendVerifyCode{
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/bankSignPhoneCodeRepeat", SGCommonURL];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:userAccessToken];
    NSDictionary *dic = @{@"token":token};
    [SGHttpTool getAll:urlStr params:dic success:^(id dictionary) {
        NSDictionary *dic = dictionary;
        NSString *rcd = dic[@"rcd"];
        NSString *rmg = dic[@"rmg"];
        if ([rcd isEqualToString:@"R0001"]) {
            [self startTimer];
        }
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:rmg delayTime:1];
    } failure:^(NSError *error) {
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"验证失败" delayTime:1];
    }];
}

- (void)reSendverifyCode:(id)sender{
    [self sendVerifyCode];
}

- (void)button_action:(id)sender{
    if (self.verifyCodeView.textField.text.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/bankSignPhoneCode", SGCommonURL];
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:userAccessToken];
        NSDictionary *dic = @{@"token":token,@"checkCode":self.verifyCodeView.textField.text};
        [SGHttpTool getAll:urlStr params:dic success:^(id dictionary) {
            NSDictionary *dic = dictionary;
            NSString *rcd = dic[@"rcd"];
            NSString *rmg = dic[@"rmg"];
            if ([rcd isEqualToString:@"M0009_1"] || [rcd isEqualToString:@"R0001"]) {
                //认证成功
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:rmg delayTime:1];
        } failure:^(NSError *error) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"失败" delayTime:1];
        }];
    }else{
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"验证码不能为空" delayTime:1];
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
- (void)dealloc{
    
}
@end
