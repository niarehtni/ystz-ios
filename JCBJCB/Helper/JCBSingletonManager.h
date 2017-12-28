//
//  JCBSingletonManager.h
//  JCBJCB
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBSingletonManager : NSObject

+ (instancetype)sharedSingletonManager;

/** 记录 JCBPushGuideView 的 cancel_btn 是否被选中*/
@property (nonatomic, assign) BOOL isSelectedCancelBtn;

/** 判断用户是否在产品详情界面登录 */
@property (nonatomic, assign) BOOL isProductDetailLogin;

/** 判断用户是否在投资确认界面进行投资 */
@property (nonatomic, assign) BOOL isSureInvestment;

/** 用户账户剩余金钱数 */
@property (nonatomic, copy) NSString *user_money;

/** 判断用户是否在修改手势密码界面进行跳转 */
@property (nonatomic, assign) BOOL isReviseGesturePWVC;

/** 判断用户是否在修改手势密码界面进行跳转到登录界面 */
@property (nonatomic, assign) BOOL isReviseGesturePWVCToLoginRegister;

/** 判断用户是否在解锁界面进行跳转到登录界面 */
@property (nonatomic, assign) BOOL isUnlockGesturePWVCToLoginRegister;

/** 判断用户是否在注册界面进行跳转到设置手势界面 */
@property (nonatomic, assign) BOOL isRegisterVCToSettingGesturePWVC;

/** 判断用户是否在 BHTML5VC 跳转到 RongBaoPayVC */
@property (nonatomic, assign) BOOL isMBHTML5VCToRongBaoPayVC;

@end
