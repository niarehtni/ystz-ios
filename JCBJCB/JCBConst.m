//
//  JCBConst.m
//  JCBJCB
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 通用的间距值 */
CGFloat const SGMargin = 10;
/** 通用的小间距值 */
CGFloat const SGSmallMargin = SGMargin * 0.5;

/************************************* 登录注册 ****************************************/
/** 登录注册分割线的X值 */
CGFloat const loginRegisterMarginSplitLineX = 50;
/** 获取验证码倒计时 */
NSInteger const registerCountDownTime = 60;

/** 登录按钮的高度(4s) */
CGFloat const SGLoginBtnWithIphone4sHeight = 41;
/** 登录注册按钮的高度(5s) */
CGFloat const SGLoginBtnWithIphone5sHeight = 44;
/** 登录注册按钮的高度(6s) */
CGFloat const SGLoginBtnWithIphone6sHeight = 47;
/** 登录注册按钮的高度(6P) */
CGFloat const SGLoginBtnWithIphone6PHeight = 50;

/** 登录注册背景View的高(4s) */
CGFloat const SGLoginRegisterBGViewWithIphone4sHeight = 20;
/** 登录注册背景View的高(5s) */
CGFloat const SGLoginRegisterBGViewWithIphone5sHeight = 25;
/** 登录注册背景View的高(6s) */
CGFloat const SGLoginRegisterBGViewWithIphone6sHeight = 30;
/** 登录注册背景View的高(6P) */
CGFloat const SGLoginRegisterBGViewWithIphone6PHeight = 35;

/** 登录注册TextField字体的大小(4s) */
CGFloat const SGLoginRegisterBtnWithIphone4sPlaceHolderLabelFont = 9.0;
/** 登录注册TextField字体的大小(5s) */
CGFloat const SGLoginRegisterBtnWithIphone5sPlaceHolderLabelFont = 11.0;
/** 登录注册TextField字体的大小(6s) */
CGFloat const SGLoginRegisterBtnWithIphone6sPlaceHolderLabelFont = 13.5;
/** 登录注册TextField字体的大小(6P) */
CGFloat const SGLoginRegisterBtnWithIphone6PPlaceHolderLabelFont = 15.5;

/************************************* 公共的URL ****************************************/


#ifdef DEBUG
NSString *const SGCommonURL = @"http://139.196.88.8/api";
NSString *const SGCommonImageURL = @"http://139.196.88.8";
#else
NSString *const SGCommonURL = @"https://www.yueshanggroup.cn/api";
NSString *const SGCommonImageURL = @"https://www.yueshanggroup.cn";
#endif



// http://192.168.0.28:8080 // 内网测试用
// http://160836c5u5.iok.la:9988 // 外网地址
// https://api.hzjcb.com // 2.0之前的正式环境
// https://www.hzjcb.com // 2.0之前的正式环境图片请求连接

/************************************* 数据存储 Key 值 ****************************************/
/** 系统版本号的 key 值 */
NSString *const CFBundleVersion = @"CFBundleShortVersionString";
/** 记录手机的 key 值 */
NSString *const userDeviceToken_key = @"userDeviceToken";
/** 用户信息的 userAccessToken 值 */
NSString *const userAccessToken = @"userAccessToken";
/** 用户信息的 userAccessToken 值 */
NSString *const userId = @"userId";
/** UITextField的placeholderLabelFont的属性名 */
NSString *const SGPlaceholderLabelFontKey = @"_placeholderLabel.font";
/** 判断用户是否在登录 signIn 值 */
NSString *const signIn = @"signIn";
/** 记录用户从哪个tabBarController.selectedIndex进入我的界面（用户退出之后又去点击我的界面） */
NSString *const comeFromTabbarIndex = @"comeFromTabbarIndex";
/** 判断用户是否点击 PushGuideView 上的 image */
NSString *const didSelectImageOfPushGuideView = @"didSelectImageOfPushGuideView";
/** 判断用户是否注册成功 */
NSString *const isSuccesfulRegistration = @"isSuccesfulRegistration";
/** 手势密码存储 key */
NSString *const gesturePassword = @"gesturePassword";
/** 开关状态 key 值 */
NSString *const switchState = @"switchState";

/************************************* 数据存储 appkey 值 ****************************************/
/** UMSocial appkey */
NSString *const UMSocialAppkey = @"59dcd5eb3eae2549b900121b";
/** JPush appkey */
NSString *const JPushAppkey = @"8eeca0da326e6c6adbe27bbe";


/** 验证码上面的文字 */
NSString *const STCountDownConstStartText = @"获取验证码";
NSString *const STCountDownConstEndText = @"重新获取";

/************************************* 字体大小 ****************************************/
/** 11号字体 */
CGFloat const SGTextFontWith11 = 11;
/** 12号字体 */
CGFloat const SGTextFontWith12 = 12;
/** 13号字体 */
CGFloat const SGTextFontWith13 = 13;
/** 14号字体 */
CGFloat const SGTextFontWith14 = 14;
/** 15号字体 */
CGFloat const SGTextFontWith15 = 15;
/** 16号字体 */
CGFloat const SGTextFontWith16 = 16;

/************************************* 红包cell的高 ****************************************/
/** 红包cell的高 */
CGFloat const redCellHeight = 95;
/** tableViewCell 默认高度高 */
CGFloat const cellDeautifulHeight = 44;



