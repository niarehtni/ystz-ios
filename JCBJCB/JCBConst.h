//
//  JCBConst.h
//  JCBJCB
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 通用的间距值 */
UIKIT_EXTERN CGFloat const SGMargin;
/** 通用的小间距值 */
UIKIT_EXTERN CGFloat const SGSmallMargin;

/************************************* 登录注册 ****************************************/
/** 登录注册分割线的X值 */
UIKIT_EXTERN CGFloat const loginRegisterMarginSplitLineX;
/** 获取验证码倒计时 */
UIKIT_EXTERN NSInteger const registerCountDownTime;

/** 登录按钮的高度(4s) */
UIKIT_EXTERN CGFloat const SGLoginBtnWithIphone4sHeight;
/** 登录按钮的高度(5s) */
UIKIT_EXTERN CGFloat const SGLoginBtnWithIphone5sHeight;
/** 登录按钮的高度(6s) */
UIKIT_EXTERN CGFloat const SGLoginBtnWithIphone6sHeight;
/** 登录按钮的高度(6P) */
UIKIT_EXTERN CGFloat const SGLoginBtnWithIphone6PHeight;

/** 登录注册背景View的高(4s) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBGViewWithIphone4sHeight;
/** 登录注册背景View的高(5s) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBGViewWithIphone5sHeight;
/** 登录注册背景View的高(6s) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBGViewWithIphone6sHeight;
/** 登录注册背景View的高(6P) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBGViewWithIphone6PHeight;

/** 登录注册TextField字体的大小(4s) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBtnWithIphone4sPlaceHolderLabelFont;
/** 登录注册TextField字体的大小(5s) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBtnWithIphone5sPlaceHolderLabelFont;
/** 登录注册TextField字体的大小(6s) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBtnWithIphone6sPlaceHolderLabelFont;
/** 登录注册TextField字体的大小(6P) */
UIKIT_EXTERN CGFloat const SGLoginRegisterBtnWithIphone6PPlaceHolderLabelFont;


/************************************* 公共的URL ****************************************/
UIKIT_EXTERN NSString *const SGCommonURL;
UIKIT_EXTERN NSString *const SGCommonImageURL;

/************************************* 数据存储 Key 值 ****************************************/
/** 系统版本号的 key 值 */
UIKIT_EXTERN NSString *const CFBundleVersion;
/** 记录手机的 key 值 */
UIKIT_EXTERN NSString *const userDeviceToken_key;
/** 用户信息的 userAccessToken 值 */
UIKIT_EXTERN NSString *const userAccessToken;
/** 用户信息的 userId 值 */
UIKIT_EXTERN NSString *const userId;
/** UITextField的placeholderLabelFont的属性名 */
UIKIT_EXTERN NSString *const SGPlaceholderLabelFontKey;
/** 判断用户是否在登录 signIn 值 */
UIKIT_EXTERN NSString *const signIn;
/** 记录用户从哪个tabBarController.selectedIndex进入我的界面（用户退出之后又去点击我的界面） */
UIKIT_EXTERN NSString *const comeFromTabbarIndex;
/** 判断用户是否点击 PushGuideView 上的 image */
UIKIT_EXTERN NSString *const didSelectImageOfPushGuideView;
/** 判断用户是否注册成功 */
UIKIT_EXTERN NSString *const isSuccesfulRegistration;
/** 手势密码存储 key 值 */
UIKIT_EXTERN NSString *const gesturePassword;
/** 开关状态 key 值 */
UIKIT_EXTERN NSString *const switchState;


/************************************* 数据存储 appkey 值 ****************************************/
/** UMSocial appkey */
UIKIT_EXTERN NSString *const UMSocialAppkey;
/** JPush appkey */
UIKIT_EXTERN NSString *const JPushAppkey;


/** 验证码上面的文字 */
UIKIT_EXTERN NSString *const STCountDownConstStartText;
UIKIT_EXTERN NSString *const STCountDownConstEndText;

/************************************* 字体大小 ****************************************/
/** 11号字体 */
UIKIT_EXTERN CGFloat const SGTextFontWith11;
/** 12号字体 */
UIKIT_EXTERN CGFloat const SGTextFontWith12;
/** 13号字体 */
UIKIT_EXTERN CGFloat const SGTextFontWith13;
/** 14号字体 */
UIKIT_EXTERN CGFloat const SGTextFontWith14;
/** 15号字体 */
UIKIT_EXTERN CGFloat const SGTextFontWith15;
/** 16号字体 */
UIKIT_EXTERN CGFloat const SGTextFontWith16;

/************************************* 红包cell的高 ****************************************/
/** 红包cell的高 */
UIKIT_EXTERN CGFloat const redCellHeight;
/** tableViewCell 默认高度高 */
UIKIT_EXTERN CGFloat const cellDeautifulHeight;


