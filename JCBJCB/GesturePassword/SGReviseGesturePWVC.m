//
//  SGReviseGesturePWVC.m
//  JCBJCB
//
//  Created by apple on 17/1/9.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SGReviseGesturePWVC.h"
#import "SGGesturePasswordView.h"
#import "SGSettingGesturePWVC.h"
#import "JCBLoginRegisterVC.h"

@interface SGReviseGesturePWVC ()
@property (nonatomic, strong) UILabel *prompt_label;
@property (nonatomic, assign) NSInteger input_PW_time;

@end

@implementation SGReviseGesturePWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证手势密码";
    self.view.backgroundColor = SGColorWithWhite;
    // Do any additional setup after loading the view.

    CGFloat GPViewX = 0.14 * [UIScreen mainScreen].bounds.size.width;
    CGFloat GPViewWH = [UIScreen mainScreen].bounds.size.width - 2 * GPViewX;
    CGFloat GPViewY = 0.5 * ([UIScreen mainScreen].bounds.size.height - GPViewWH - navigationAndStatusBarHeight);
    SGGesturePasswordView *GPView = [SGGesturePasswordView gesturePasswordViewWithFrame:CGRectMake(GPViewX, GPViewY, GPViewWH, GPViewWH)];
    [self.view addSubview:GPView];
    
    // 监听手势密码的变化
    [SGNotificationCenter addObserver:self selector:@selector(selectedButtonArray:) name:@"reviseGesturePassword" object:nil];
    [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVC = NO;

    // 输入提示Label
    self.prompt_label = [[UILabel alloc] init];
    CGFloat prompt_labelW = [UIScreen mainScreen].bounds.size.width;
    CGFloat prompt_labelH = 30;
    CGFloat prompt_labelX = 0;
    CGFloat prompt_labelY = CGRectGetMinY(GPView.frame) - 2 * prompt_labelH;
    _prompt_label.frame = CGRectMake(prompt_labelX, prompt_labelY, prompt_labelW, prompt_labelH);
    _prompt_label.text = @"请输入原手势密码";
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
    UIAlertController *alertController = [UIAlertController SG_alertControllerWithTitle:@"温馨提示" message:@"登录成功后，原手势密码密码将失效，您可以在“我的-设置-手势密码”中，重新设置手势密码" sureBtn:@"重新登录" cancelBtn:@"取消" preferredStyle:(UIAlertControllerStyleAlert) sureBtnAction:^{
        [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVCToLoginRegister = YES;
        
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

    } cancelBtnAction:^{
        
    }];
     
    [self presentViewController:alertController animated:YES completion:^{
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
    if ([temp_str isEqualToString:[SGUserDefaults objectForKey:gesturePassword]] && [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVC == NO) {
            self.input_PW_time = 4;
            [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
        
            [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVC = YES;
            
            SGSettingGesturePWVC *settingGPWVC = [[SGSettingGesturePWVC alloc] init];
            [self.navigationController pushViewController:settingGPWVC animated:YES];
        } else {
            if ([SGUserDefaults integerForKey:@"input_PW_time"] == 0) {
                UIAlertController *alertC = [UIAlertController SG_alertControllerWithTitle:@"手势密码已失效" message:@"请重新登录" btnTitle:@"重新登录" preferredStyle:(UIAlertControllerStyleAlert) sureBtnAction:^{
                    [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVCToLoginRegister = YES;
                    
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
            } else {
                self.input_PW_time = [SGUserDefaults integerForKey:@"input_PW_time"];
                self.prompt_label.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次", (long)self.input_PW_time];
                self.prompt_label.textColor = [UIColor redColor];
                // 让提示文字抖动效果
                [self promptLabelTextShake];
                
                self.input_PW_time --;
                [SGUserDefaults setInteger:self.input_PW_time forKey:@"input_PW_time"];
            }
        }
}


#pragma mark - - - 让提示文字抖动效果
- (void)promptLabelTextShake {
    CAKeyframeAnimation *KFA = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat length = 5;
    // 移动位置的数值
    KFA.values = @[@(-length),@(0),@(length),@(0),@(-length),@(0),@(length),@(0)];
    // 时长
    KFA.duration = 0.2f;
    // 重复
    KFA.repeatCount = 2;
    // 移除(暂未发现有什么问题)
    KFA.removedOnCompletion = YES;
    [self.prompt_label.layer addAnimation:KFA forKey:@"shake"];
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
