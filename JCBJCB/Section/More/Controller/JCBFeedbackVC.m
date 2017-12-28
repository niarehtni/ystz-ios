//
//  JCBFeedbackVC.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBFeedbackVC.h"

@interface JCBFeedbackVC ()
@property (nonatomic, strong) SGTextView *textView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation JCBFeedbackVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SGCommonBgColor;
    self.title = @"意见反馈";
    
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(fingerTapped)];

}

- (void)fingerTapped {
    [self.view endEditing:YES];
}

- (void)setupSubviews {
    
    CGFloat margin = 15;
    CGFloat width = SG_screenWidth - 2 * margin;
    
    self.textView = [[SGTextView alloc] init];
    _textView.frame = CGRectMake(margin, 10, width, SG_screenHeight * 0.25);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.placeholder = @" 欢迎您向我们发送反馈意见";
    [self.view addSubview:_textView];
    
    
    self.textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(margin, CGRectGetMaxY(_textView.frame) + 10, width, 30);
    _textField.SG_placeholderColor = [UIColor grayColor];
    _textField.placeholder = @" 留下您的手机号或邮箱，以便给您答案";
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textField];
    
    UIButton *send_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    send_btn.frame = CGRectMake(margin, CGRectGetMaxY(_textField.frame) + 35, width, 50);
    send_btn.backgroundColor = SGCommonRedColor;
    [send_btn setTitle:@"提交" forState:(UIControlStateNormal)];
    send_btn.layer.cornerRadius = 5;
    send_btn.layer.masksToBounds = YES;
    [send_btn addTarget:self action:@selector(send_btn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:send_btn];
}

- (void)send_btn_action {
    [self.view endEditing:YES];

    if (_textView.text.length == 0) {
        SGAlertView *alert = [SGAlertView alertViewWithTitle:@"提示" delegate:nil contentTitle:@"反馈信息不能为空" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alert show];
        
    } else if (_textField.text.length == 0) {
        SGAlertView *alert = [SGAlertView alertViewWithTitle:@"提示" delegate:nil contentTitle:@"请输入您的手机号码或邮箱，以方便我们与您取得联系" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alert show];

    } else {
    
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在上传中...请稍等" toView:self.navigationController.view];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/adFeedbackNew", SGCommonURL];
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"content"] = self.textView.text;
        params[@"contact"] = self.textField.text;

        [SGHttpTool postAll:urlStr params:params success:^(id json) {
            [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
            SGDebugLog(@"json - - %@", json);
            if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"反馈成功" delayTime:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", json[@"rmg"]] delayTime:1.0];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
            SGDebugLog(@"error - - %@", error);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


