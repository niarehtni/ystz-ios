//
//  SGProgressHUDTool.m
//  SGProgressHUDTool
//
//  Created by Sorgle on 2015/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import "SGProgressHUDTool.h"
#import "MBProgressHUD.h"

@implementation SGProgressHUDTool

+ (void)SG_showMBProgressHUDWithOnlyMessage:(NSString *)message delayTime:(CGFloat)time {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hideAnimated:YES afterDelay:time];
}

/** 只显示文字的 12 号字体 MBProgressHUD */
+ (void)SG_showMBProgressHUDWithOnlySmallMessage:(NSString *)message delayTime:(CGFloat)time {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:13.0];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hideAnimated:YES afterDelay:time];
}


@end
