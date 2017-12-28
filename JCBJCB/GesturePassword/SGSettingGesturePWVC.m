//
//  SGSettingGesturePWVC.m
//  SG_GesturePassword
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SGSettingGesturePWVC.h"
#import "SGGesturePasswordView.h"
#import "JCBAccountSettingVC.h"
#import "AppDelegate.h"
#import "JCBTabBarController.h"

@interface SGSettingGesturePWVC ()
@property (nonatomic, strong) UILabel *prompt_label;
@property (nonatomic, assign) BOOL first_draw_PW;
@property (nonatomic, strong) NSMutableArray *small_GPW_MArr;

@end

@implementation SGSettingGesturePWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置手势密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.first_draw_PW = YES;
    
    CGFloat GPViewX = 0.14 * [UIScreen mainScreen].bounds.size.width;
    CGFloat GPViewWH = [UIScreen mainScreen].bounds.size.width - 2 * GPViewX;
    CGFloat GPViewY;
    if ([JCBSingletonManager sharedSingletonManager].isRegisterVCToSettingGesturePWVC == YES) {
        GPViewY = 0.5 * ([UIScreen mainScreen].bounds.size.height - GPViewWH);
    } else {
        GPViewY = 0.5 * ([UIScreen mainScreen].bounds.size.height - GPViewWH - navigationAndStatusBarHeight);
    }
    SGGesturePasswordView *GPView = [SGGesturePasswordView gesturePasswordViewWithFrame:CGRectMake(GPViewX, GPViewY, GPViewWH, GPViewWH)];
    [self.view addSubview:GPView];

    // 监听手势密码的变化
    [SGNotificationCenter addObserver:self selector:@selector(selectedButtonArray:) name:@"selectedButtonArray" object:nil];
    
    // 输入提示Label
    self.prompt_label = [[UILabel alloc] init];
    CGFloat prompt_labelW = [UIScreen mainScreen].bounds.size.width;
    CGFloat prompt_labelH = 30;
    CGFloat prompt_labelX = 0;
    CGFloat prompt_labelY = CGRectGetMinY(GPView.frame) - 1.2 * prompt_labelH;
    _prompt_label.frame = CGRectMake(prompt_labelX, prompt_labelY, prompt_labelW, prompt_labelH);
    _prompt_label.text = @"绘制解锁图案";
    _prompt_label.font = [UIFont systemFontOfSize:SGTextFontWith15];
    _prompt_label.textColor = SGColorWithBlackOfDark;
    _prompt_label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_prompt_label];
    
    // 绘制小的手势提示
    [self setupSmallGesturePassWordView];
}

#pragma mark - - - 绘制小的手势提示
- (void)setupSmallGesturePassWordView {
    UIView *topView = [[UIView alloc] init];
    CGFloat topVIewWH = 70;
    CGFloat topVIewX = ([UIScreen mainScreen].bounds.size.width - topVIewWH) * 0.5;
    CGFloat topVIewY = CGRectGetMinY(_prompt_label.frame) - topVIewWH - 10;
    topView.frame = CGRectMake(topVIewX, topVIewY, topVIewWH, topVIewWH);
    //topView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:topView];
    
    self.small_GPW_MArr = [NSMutableArray array];
    
    // button列数
    int column = 3;
    // button距离父视图的间距
    CGFloat toSuperViewMargin = 2;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat buttonWH = 18;
    
    // button之间的间距
    CGFloat margin = (topVIewWH - buttonWH * column - 2 * toSuperViewMargin) / (column - 1);
    
    for (int i = 0; i < 9; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_norma_smalll"] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        int currentColumn = i % column;
        int currentRow = i / column;
        x = toSuperViewMargin + currentColumn * (buttonWH + margin);
        y = toSuperViewMargin + currentRow * (buttonWH + margin);
        btn.frame = CGRectMake(x, y, buttonWH, buttonWH);
        [self.small_GPW_MArr addObject:btn];
        [topView addSubview:btn];
    }
}

#pragma mark - - - 监听手势密码的绘制
- (void)selectedButtonArray:(NSNotification *)noti {

    NSArray *temp_Arr = noti.object;
    if (temp_Arr.count < 4) {
        self.prompt_label.text = @"至少连接4个点，请重新输入";
        self.prompt_label.textColor = [UIColor redColor];
        // 让提示文字抖动效果
        [self promptLabelTextShake];
    } else {
        SGDebugLog(@"gesturePassword - - %@", [SGUserDefaults objectForKey:gesturePassword]);
        if (self.first_draw_PW) { // 第一次绘制
            
            // 改变smallGesturePassWord上面颜色的变化
            [temp_Arr enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
                //SGDebugLog(@"idx=%lu, id=%@", (unsigned long)index, object);
                NSInteger selectedBtnTag = [object integerValue];
                UIButton *small_btn = self.small_GPW_MArr[selectedBtnTag];
                [small_btn setImage:[UIImage imageNamed:@"gesture_node_selected_small"] forState:UIControlStateNormal];
            }];
            
            // 提示绘制内容
            self.prompt_label.text = @"再次绘制解锁图案";
            self.prompt_label.textColor = SGColorWithBlackOfDark;
            
            // 数组转字符串
            NSString *temp_str = [temp_Arr componentsJoinedByString:@""];

            [SGUserDefaults setObject:temp_str forKey:gesturePassword];
            [SGUserDefaults synchronize];
            
            self.first_draw_PW = NO;
        } else { // 第二次绘制
            // 数组转字符串
            NSString *two_temp_str = [temp_Arr componentsJoinedByString:@""];
            if ([two_temp_str isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:gesturePassword]]) { // 2 次密码一致
                //self.prompt_label.text = @"再次绘制解锁图案";
                //self.prompt_label.textColor = [UIColor blackColor];
                [self.prompt_label removeFromSuperview];
                
                [MBProgressHUD SG_showMBProgressHUDOfSuccessMessage:@"设置成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD SG_hideHUD];
                    // 保存开关的状态
                    [SGUserDefaults setObject:@"on" forKey:switchState];
                    [SGUserDefaults synchronize];
                    
                    if ([JCBSingletonManager sharedSingletonManager].isReviseGesturePWVC == YES) { // 用户是从重置手势密码界面跳转过来的
                        for (UIViewController *VC in self.navigationController.viewControllers) {
                            if ([VC isKindOfClass:[JCBAccountSettingVC class]]) {
                                JCBAccountSettingVC *ASVC = (JCBAccountSettingVC *)VC;
                                [self.navigationController popToViewController:ASVC animated:YES];
                            }
                        }
                        [JCBSingletonManager sharedSingletonManager].isReviseGesturePWVC = NO;
                    } else if ([JCBSingletonManager sharedSingletonManager].isRegisterVCToSettingGesturePWVC == YES) { // 用户是从注册界面跳转过来的
                        [JCBSingletonManager sharedSingletonManager].isRegisterVCToSettingGesturePWVC = NO;
                        
                        // 设置完成之后进行界面跳转
                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
                        appDelegate.window.rootViewController = tabBarC;
                        tabBarC.selectedIndex = 0;
                        
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                });
            } else { // 2 次密码不一致
                self.prompt_label.text = @"与上一次绘制不一致，请重新绘制";
                self.prompt_label.textColor = [UIColor redColor];
                [self promptLabelTextShake];
                
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(newDrawPassWord) title:@"重设" titleColor:[UIColor blackColor] titleFond:[UIFont systemFontOfSize:15]];

            }
        }
    }
}

- (void)newDrawPassWord {
    [SGUserDefaults setObject:nil forKey:gesturePassword];
    [SGUserDefaults synchronize];
    
    self.prompt_label.text = @"绘制解锁图案";
    self.prompt_label.textColor = SGColorWithBlackOfDark;
    self.first_draw_PW = YES;
    
    // 让smallGesturePassWord恢复默认图片
    for (int i = 0; i < 9; i++) {
        UIButton *small_btn = self.small_GPW_MArr[i];
        [small_btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
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



@end

