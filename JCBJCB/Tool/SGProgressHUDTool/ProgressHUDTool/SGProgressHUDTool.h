//
//  SGProgressHUDTool.h
//  SGProgressHUDTool
//
//  Created by Sorgle on 2015/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGProgressHUDTool : NSObject

/** 只显示文字的 15 号字体（文字最好不要超过 14 个汉字） MBProgressHUD */
+ (void)SG_showMBProgressHUDWithOnlyMessage:(NSString *)message delayTime:(CGFloat)time;

/** 只显示文字的 13 号字体 MBProgressHUD */
+ (void)SG_showMBProgressHUDWithOnlySmallMessage:(NSString *)message delayTime:(CGFloat)time;

@end
