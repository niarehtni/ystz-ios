//
//  MBProgressHUD+SG.h
//  SGMBProgressHUD
//
//  Created by Sorgle on 16/5/16.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SG)

/** MBProgressHUD修改后的样式 添加到self.navigationController.view上，导航栏也不能被点击 */
+ (MBProgressHUD *)SG_showMBProgressHUDWithModifyStyleMessage:(NSString *)message toView:(UIView *)view;
/** MBProgressHUD系统自带样式 添加到self.navigationController.view上，导航栏也不能被点击 */
+ (MBProgressHUD *)SG_showMBProgressHUDWithSystemComesStyleMessage:(NSString *)message toView:(UIView *)view;
/** 10s之后隐藏 */
+ (MBProgressHUD *)SG_showMBProgressHUD10sHideWithModifyStyleMessage:(NSString *)message toView:(UIView *)view;

/** 显示加载成功的 MBProgressHUD */
+ (void)SG_showMBProgressHUDOfSuccessMessage:(NSString *)message toView:(UIView *)view;
/** 显示加载成功的 MBProgressHUD (简洁版) */
+ (void)SG_showMBProgressHUDOfSuccessMessage:(NSString *)message;


/** 显示加载失败的 MBProgressHUD */
+ (void)SG_showMBProgressHUDOfErrorMessage:(NSString *)message toView:(UIView *)view;
/** 显示加载失败的 MBProgressHUD (简洁版) */
+ (void)SG_showMBProgressHUDOfErrorMessage:(NSString *)message;


/** 隐藏MBProgressHUD 要与添加的view保持一致 */
+ (void)SG_hideHUDForView:(UIView *)view;
+ (void)SG_hideHUD;

@end
