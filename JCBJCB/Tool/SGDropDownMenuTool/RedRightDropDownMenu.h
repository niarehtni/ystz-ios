//
//  RedRightDropDownMenu.h
//  DropDownMenu
//
//  Created by Sorgle on 16/5/1.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RedRightDropDownMenu;

@protocol RedRightDropDownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(RedRightDropDownMenu *)menu;
- (void)dropdownMenuDidShow:(RedRightDropDownMenu *)menu;
@end

@interface RedRightDropDownMenu : UIView
@property (nonatomic, weak) id<RedRightDropDownMenuDelegate> delegate_dropDown;
+ (instancetype)menu;

/** 显示 */
- (void)showFrom:(UIView *)from;
/** 销毁 */
- (void)dismiss;

/**  内容 */
@property (nonatomic, strong) UIView *content;
/**  内容控制器 */
@property (nonatomic, strong) UIViewController *contentController;

@end


