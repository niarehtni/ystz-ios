//
//  JCBLoginPWSettingVC.m
//  JCBJCB
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBLoginPWSettingVC.h"
#import "JCBForgetPasswordVC.h"

@interface JCBLoginPWSettingVC ()
@property (weak, nonatomic) IBOutlet UITextField *originalPWTF;
@property (weak, nonatomic) IBOutlet UITextField *NewPWTF;
@property (weak, nonatomic) IBOutlet UITextField *againNewPWTF;
@property (weak, nonatomic) IBOutlet UIButton *sureModifyBtn;

@end

@implementation JCBLoginPWSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改登录密码";
    self.view.backgroundColor = SGCommonBgColor;
    
    [SGSmallTool SG_smallWithTapGestureRecognizerToThisView:self.view target:self action:@selector(fingerTapped:)];

    [self setupSubviews];
}

#pragma mark - - - 手势点击事件
- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)setupSubviews {
    [SGSmallTool SG_smallWithThisView:self.originalPWTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.NewPWTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.againNewPWTF cornerRadius:5];
    [SGSmallTool SG_smallWithThisView:self.sureModifyBtn cornerRadius:5];
    
    self.originalPWTF.tintColor = SGColorWithRed;
    self.NewPWTF.tintColor = SGColorWithRed;
    self.againNewPWTF.tintColor = SGColorWithRed;

#pragma mark - - - 统一设置SGPlaceholderLabel字体的大小
    if (iphone5s) {
        CGFloat labelFont5s = 13;
        [self.originalPWTF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.NewPWTF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.againNewPWTF setValue:[UIFont boldSystemFontOfSize:labelFont5s] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone6s) {
        CGFloat labelFont6s = 14;
        [self.originalPWTF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.NewPWTF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
        [self.againNewPWTF setValue:[UIFont boldSystemFontOfSize:labelFont6s] forKeyPath:SGPlaceholderLabelFontKey];
    } else if (iphone6P) {
        CGFloat labelFont6P = 15;
        [self.originalPWTF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
        [self.NewPWTF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
        [self.againNewPWTF setValue:[UIFont boldSystemFontOfSize:labelFont6P] forKeyPath:SGPlaceholderLabelFontKey];
    }
}

/** 忘记密码按钮的点击事件 */
- (IBAction)forgetPasswordBtn_action:(id)sender {
    JCBForgetPasswordVC *forgetPWVC = [[JCBForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:forgetPWVC animated:YES];
}

/** 确认修改密码按钮的点击事件 */
- (IBAction)sureModifyBtn_action:(id)sender {
    if (self.originalPWTF.text.length == 0) { // 原密码为空提示
        [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请填写原密码" delayTime:0.5];
    } else {
        if (self.NewPWTF.text.length == 0) { // 新密码为空提示
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"请输入新密码" delayTime:0.5];
        } else if (self.NewPWTF.text.length < 6 || self.NewPWTF.text.length > 16) {
            [SGProgressHUDTool SG_showMBProgressHUDWithOnlySmallMessage:@"密码由6-16位数字、字母及符号组成" delayTime:1.0];
        } else {  // 已输入新密码
            if (self.againNewPWTF.text.length == 0) { // 再次输入新密码不能为空
                [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"再次输入新密码不能为空" delayTime:0.5];
            } else {
                if ([self.NewPWTF.text isEqualToString:self.againNewPWTF.text]) { // 这次才能进行重置密码
                    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userLoginPwdUpdate?oldPassword=%@&newPassword=%@", SGCommonURL, self.originalPWTF.text, self.NewPWTF.text];
                    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
                    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
                        SGDebugLog(@"json - - - %@", json);
                        if ([json[@"rcd"] isEqualToString:@"R0001"]){
                            [SGProgressHUDTool SG_showMBProgressHUDWithOnlySmallMessage:@"修改成功" delayTime:1.5];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        } else {
                            [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:[NSString stringWithFormat:@"%@", json[@"rmg"]] delayTime:1.0];
                        }
                    } failure:^(NSError *error) {
                        SGDebugLog(@"error - - - %@", error);
                    }];

                } else { // 两次输入新密码不一致
                    [SGProgressHUDTool SG_showMBProgressHUDWithOnlyMessage:@"两次输入新密码不一致" delayTime:1.0];
                }
            }
        }
    }
}



@end


