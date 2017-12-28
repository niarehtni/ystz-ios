//
//  RightDropDownMenu.h
//  DropDownMenu
//
//  Created by Sorgle on 16/5/1.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightDropDownMenu;

@protocol RightDropDownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(RightDropDownMenu *)menu;
- (void)dropdownMenuDidShow:(RightDropDownMenu *)menu;
@end

@interface RightDropDownMenu : UIView
@property (nonatomic, weak) id<RightDropDownMenuDelegate> delegate;
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


