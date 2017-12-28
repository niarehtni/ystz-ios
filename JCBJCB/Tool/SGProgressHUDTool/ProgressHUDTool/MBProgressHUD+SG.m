//
//  MBProgressHUD+SG.m
//  SGMBProgressHUD
//
//  Created by Sorgle on 16/5/16.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "MBProgressHUD+SG.h"

@implementation MBProgressHUD (SG)

/** MBProgressHUD 修改后的样式 */
+ (MBProgressHUD *)SG_showMBProgressHUDWithModifyStyleMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.bezelView.color = [UIColor blackColor];
    // 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:5];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
/** MBProgressHUD 自带样式 */
+ (MBProgressHUD *)SG_showMBProgressHUDWithSystemComesStyleMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    [hud hideAnimated:YES afterDelay:5];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


#pragma mark - - - 显示信息
+ (void)showMessage:(NSString *)message icon:(NSString *)icon toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.bezelView.color = [UIColor blackColor];
    // 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}

/** 显示加载成功的 MBProgressHUD */
+ (void)SG_showMBProgressHUDOfSuccessMessage:(NSString *)message toView:(UIView *)view {
    [self showMessage:message icon:@"success" toView:view];
}
/** 显示加载成功的 MBProgressHUD (简洁版) */
+ (void)SG_showMBProgressHUDOfSuccessMessage:(NSString *)message {
    [self SG_showMBProgressHUDOfSuccessMessage:message toView:nil];
}


/** 显示加载失败的 MBProgressHUD */
+ (void)SG_showMBProgressHUDOfErrorMessage:(NSString *)message toView:(UIView *)view {
    [self showMessage:message icon:@"error" toView:view];
}
/** 显示加载失败的 MBProgressHUD (简洁版) */
+ (void)SG_showMBProgressHUDOfErrorMessage:(NSString *)message {
    [self SG_showMBProgressHUDOfErrorMessage:message toView:nil];
}


#pragma mark - - - 隐藏MBProgressHUD
/** 隐藏 MBProgressHUD */
+ (void)SG_hideHUDForView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)SG_hideHUD {
    [self SG_hideHUDForView:nil];
}

/** MBProgressHUD 修改后的样式 (10s) */
+ (MBProgressHUD *)SG_showMBProgressHUD10sHideWithModifyStyleMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.bezelView.color = [UIColor blackColor];
    // 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:10];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


@end


