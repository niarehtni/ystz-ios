//
//  JCBForgetPasswordVC.h
//  JCBJCB
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    whereAreFromeVCOne,
    whereAreFromeVCTwo,
} whereAreFromeVC;

@interface JCBForgetPasswordVC : UIViewController

/** 判断是哪个控制器push进来的（JCBLoginVC or JCBLoginPWSettingVC） */
@property (nonatomic, assign) whereAreFromeVC fromeVC;

@end
