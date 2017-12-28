//
//  AppDelegate.m
//  JCBJCB
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "AppDelegate.h"
#import "JCBTabBarController.h"
#import "JCBLoginRegisterVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "NewFeatureViewController.h"
#import "MeiQiaSDK/MQManager.h"
#import "SGUnlockVC.h"
#import "NewFeatureViewController.h"
#import <UShareUI/UShareUI.h>

@interface AppDelegate () <UITabBarControllerDelegate, JPUSHRegisterDelegate>

@end

@implementation AppDelegate

#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:signIn];

    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 设置根控制器 (启动界面)
#pragma mark - - - 第一次下载或者版本更新才会出现的版本新特性
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [SGUserDefaults objectForKey:CFBundleVersion];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[CFBundleVersion];
    
    if (![currentVersion isEqualToString:lastVersion]) { // 版本号不相同：这次打开的版本和上一次不一样，显示新特性
        // 将当前的版本号存进沙盒
        [SGUserDefaults setObject:currentVersion forKey:CFBundleVersion];
        [SGUserDefaults synchronize];
        
        NewFeatureViewController *newFVC = [[NewFeatureViewController alloc] init];
        self.window.rootViewController = newFVC;
    } else {
        if (!([SGUserDefaults objectForKey:gesturePassword] == nil) && !([SGUserDefaults objectForKey:userAccessToken] == nil)) {
            SGUnlockVC *unlockVC = [[SGUnlockVC alloc] init];
            self.window.rootViewController = unlockVC;
        } else {
            JCBTabBarController *tabBarC = [[JCBTabBarController alloc] init];
            self.window.rootViewController = tabBarC;
        }
    }

#pragma mark - - - UMSocial
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMSocialAppkey];
    
    // 获取友盟social版本号
    //SGDebugLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx021f5a9de35cd071" appSecret:@"a5c02074924673cb9f9cd271d6d33096" redirectURL:@"www.yueshanggroup.cn"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106377024"  appSecret:@"AU5BmxakUglJKgkS" redirectURL:@"www.yueshanggroup.cn"];
    
    
    NSArray *avalarray = [UMSocialManager defaultManager].platformTypeArray;
    NSArray *allowArray = @[@(UMSocialPlatformType_WechatSession),
                            @(UMSocialPlatformType_WechatTimeLine),
//                            @(UMSocialPlatformType_WechatFavorite),
                            @(UMSocialPlatformType_QQ),
                            @(UMSocialPlatformType_Qzone),
//                            @(UMSocialPlatformType_TencentWb)
                            ];
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:avalarray];
    [set1 intersectSet:[NSSet setWithArray:allowArray]];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray *userArray = [set1 sortedArrayUsingDescriptors:@[sd]];
    [UMSocialUIManager setPreDefinePlatforms:userArray];

#pragma mark - - - UMMobClick
    // 友盟的方法本身是异步执行，所以不需要再异步调用
    UMConfigInstance.appKey = UMSocialAppkey;
    UMConfigInstance.channelId = nil; // 渠道 nil,@""：默认 App Store
    [MobClick startWithConfigure:UMConfigInstance]; // 配置以上参数后调用此方法初始化SDK！
        
    // 进行版本号数据统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:CFBundleVersion];
    SGDebugLog(@"version - - - %@", version);
    [MobClick setAppVersion:version];
    
#pragma mark - - - JPush
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    // Required
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    }else{
        entity.types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 部分参数说明：
    // channel 指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
    // apsForProduction 1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。 注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
    // advertisingIdentifier
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppkey channel:@"App Store" apsForProduction:isProduction advertisingIdentifier:advertisingId];
    
#pragma mark - - - MeiQia
//    [MQManager initWithAppkey:@"ec1919ae01878903c5b9aae13ad85238" completion:^(NSString *clientId, NSError *error) {
//        if (!error) {
//            SGDebugLog(@"美洽 SDK：初始化成功");
//        } else {
//            SGDebugLog(@"美洽 SDK - error: %@", error);
//        }
//    }];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - - - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    NSUserDefaults *UD_aT = [[NSUserDefaults standardUserDefaults] objectForKey:userAccessToken];
    SGDebugLog(@"UD_aT - - - %@", UD_aT);
    // 判断用户是否登陆
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:userAccessToken] length] > 0) {
        return YES;
        
    } else {
        
        if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
            JCBLoginRegisterVC * loginVC = [[JCBLoginRegisterVC alloc] init];
            UINavigationController *newNavigationC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            // 模态导航控制器
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:newNavigationC animated:YES completion:^{
                
            }];
            return NO;
        }
    }
    return YES;
}


#pragma mark - - - UMSocialDelegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - - - JPush 回调方法
// 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    [AppDelegate configJpushTag];
    
    
    SGDebugLog(@"didRegisterForRemoteNotificationsWithDeviceToken,%@",deviceToken);
}

+ (void)configJpushTag{
//    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:userId];
    

    [JPUSHService setTags:[NSSet setWithObjects:@"tag_all", nil] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        SGDebugLog(@"极光推送设置tag,%ld",iResCode);
    } seq:0];
}

// 实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    SGDebugLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    SGDebugLog(@"notificationSettings - - %@", notificationSettings);
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        SGDebugLog(@"iOS10  收到远程通知:%@", [self logDic:userInfo]);
        
    } else {
        // 判断为本地通知
        SGDebugLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        SGDebugLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    } else {
        // 判断为本地通知
        SGDebugLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // JPush
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // App 进入后台时，关闭美洽服务
    [MQManager closeMeiqiaService];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    // JPush
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    // App 进入前台时，开启美洽服务
    [MQManager openMeiqiaService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
