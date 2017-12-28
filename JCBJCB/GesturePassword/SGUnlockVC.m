//
//  SGUnlockVC.m
//  JCBJCB
//
//  Created by apple on 17/1/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SGUnlockVC.h"
#import "SGGesturePasswordView.h"
#import "JCBLoginRegisterVC.h"
#import "AppDelegate.h"
#import "JCBTabBarController.h"

@interface SGUnlockVC ()
@property (nonatomic, strong) UILabel *prompt_label;
@property (nonatomic, assign) int input_PW_time;
@end

@implementation SGUnlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat GPViewX = 0.14 * [UIScreen mainScreen].bounds.size.width;
    CGFloat GPViewWH = [UIScreen mainScreen].bounds.size.width - 2 * GPViewX;
    CGFloat GPViewY = 0.5 * ([UIScreen mainScreen].bounds.size.height - GPViewWH);
    SGGesturePasswordView *GPView = [SGGesturePasswordView gesturePasswordViewWithFrame:CGRectMake(GPViewX, GPViewY, GPViewWH, GPViewWH)];
    [self.view addSubview:GPView];
    
    // 监听手势密码的变化
    [SGNotificationCenter addObserver:self selector:@selector(selectedButtonArray:) name:@"unlockGesturePassword" object:nil];
    [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVC = NO;
    
    // 输入提示Label
    self.prompt_label = [[UILabel alloc] init];
    CGFloat prompt_labelW = [UIScreen mainScreen].bounds.size.width;
    CGFloat prompt_labelH = 30;
    CGFloat prompt_labelX = 0;
    CGFloat prompt_labelY = CGRectGetMinY(GPView.frame) - 2 * prompt_labelH;
    _prompt_label.frame = CGRectMake(prompt_labelX, prompt_labelY, prompt_labelW, prompt_labelH);
    _prompt_label.text = @"请输入手势密码";
    _prompt_label.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _prompt_label.textColor = SGColorWithBlackOfDark;
    _prompt_label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_prompt_label];
    
    // 忘记手势密码提示
    UIButton *button = [[UIButton alloc] init];
    CGFloat buttonW = 100;
    CGFloat buttonH = 40;
    CGFloat buttonX = (SG_screenWidth - buttonW) * 0.5;
    CGFloat buttonY = SG_screenHeight - buttonH - SGMargin - SGSmallMargin - navigationAndStatusBarHeight;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    //button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@"忘记手势密码" forState:(UIControlStateNormal)];
    [button setTitleColor:SGColorWithRGB(55, 121, 184) forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [button addTarget:self action:@selector(forgetGesturePassword) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    [self once];
}

#pragma mark - - - 忘记手势密码
- (void)forgetGesturePassword {
    UIAlertController *alertC = [UIAlertController SG_alertControllerWithTitle:@"温馨提示" message:@"登录成功后，原手势密码密码将失效，您可以在“我的-设置-手势密码”中，重新设置手势密码" btnTitle:@"重新登录" preferredStyle:(UIAlertControllerStyleAlert) sureBtnAction:^{
        [JCBSingletonManager sharedSingletonManager].isUnlockGesturePWVCToLoginRegister = YES;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/logout", SGCommonURL];
        [SGHttpTool getAll:urlStr params:nil success:^(id json) {
            SGDebugLog(@"%@", json);
            if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                [SGUserDefaults setObject:nil forKey:userAccessToken];
                // 立即同步
                [SGUserDefaults synchronize];
            }
        } failure:^(NSError *error) {
            SGDebugLog(@"error - - - %@", error);
        }];
        // 关闭手势密码按钮
        [SGUserDefaults setObject:nil forKey:switchState];
        [SGUserDefaults setObject:nil forKey:gesturePassword];
        [SGUserDefaults synchronize];
        
        self.input_PW_time = 4;
        [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        JCBLoginRegisterVC *loginRegisterVC = [[JCBLoginRegisterVC alloc] init];
        [self presentViewController:loginRegisterVC animated:YES completion:nil];
        
    }];
    [self presentViewController:alertC animated:YES completion:^{
    }];
    
}

- (void)once {
    // 整个应用程序只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.input_PW_time = 4;
        [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
    });
}


#pragma mark - - - 监听手势密码的绘制
- (void)selectedButtonArray:(NSNotification *)noti {
    self.input_PW_time = (int)[SGUserDefaults integerForKey:@"input_PW_time"];
    NSString *temp_str = [noti.object componentsJoinedByString:@""];
    if ([[SGUserDefaults objectForKey:gesturePassword] isEqualToString:temp_str]) { // 手势密码正确
        JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
        AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appD.window.rootViewController = tabBarC;
        
        self.input_PW_time = 4;
        [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
    } else { // 手势密码不正确
        if ([SGUserDefaults integerForKey:@"input_PW_time"] == 0) {
            UIAlertController *alertC = [UIAlertController SG_alertControllerWithTitle:@"手势密码已失效" message:@"请重新登录" btnTitle:@"重新登录" preferredStyle:(UIAlertControllerStyleAlert) sureBtnAction:^{
                [JCBSingletonManager sharedSingletonManager].isUnlockGesturePWVCToLoginRegister = YES;
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/rest/logout", SGCommonURL];
                [SGHttpTool getAll:urlStr params:nil success:^(id json) {
                    SGDebugLog(@"%@", json);
                    if ([json[@"rcd"] isEqualToString:@"R0001"]) {
                        [SGUserDefaults setObject:nil forKey:userAccessToken];
                        // 立即同步
                        [SGUserDefaults synchronize];
                    }
                } failure:^(NSError *error) {
                    SGDebugLog(@"error - - - %@", error);
                }];
                // 关闭手势密码按钮
                [SGUserDefaults setObject:nil forKey:switchState];
                [SGUserDefaults setObject:nil forKey:gesturePassword];
                self.input_PW_time = 4;
                [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
                [SGUserDefaults synchronize];

                JCBLoginRegisterVC *loginRegisterVC = [[JCBLoginRegisterVC alloc] init];
                [self presentViewController:loginRegisterVC animated:YES completion:nil];
            }];
            [self presentViewController:alertC animated:YES completion:^{
            }];
        } else {
            self.prompt_label.text = [NSString stringWithFormat:@"密码错误，还可以再输入%d次", self.input_PW_time];
            self.prompt_label.textColor = [UIColor redColor];
            // 让提示文字抖动效果
            [self.prompt_label.layer SG_textShake];
            
            self.input_PW_time --;
            [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
        }
    }

}



- (void)dealloc {
    SGDebugLog(@"dealloc");
    [SGNotificationCenter removeObserver:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
