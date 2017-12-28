//
//  JCBTabBarController.m
//  JCBJCB
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBTabBarController.h"
#import "JCBNavigationController.h"
#import "JCBHomeVC.h"
#import "JCBProductVC.h"
#import "JCBMineVC.h"
#import "JCBMoreVC.h"
#import "JCBLoginRegisterVC.h"

@interface JCBTabBarController ()

@end

@implementation JCBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**** 设置所有UITabBarItem的文字属性 ****/
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    /**** 添加子控制器 ****/
    [self setupOneChildViewController:[[JCBHomeVC alloc] init] title:@"乐商贷" imageName:@"tabBar_home" selectedImageName:@"tabBar_home_selected"];
    [self setupOneChildViewController:[[JCBProductVC alloc] init] title:@"产品" imageName:@"tabBar_list" selectedImageName:@"tabBar_list_selected"];
    [self setupOneChildViewController:[[JCBMineVC alloc] init] title:@"我的" imageName:@"tabBar_mine" selectedImageName:@"tabBar_mine_selected"];
    [self setupOneChildViewController:[[JCBMoreVC alloc] init] title:@"更多" imageName:@"tabBar_more" selectedImageName:@"tabBar_more_selected"];
}

/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param imageName         图标名
 *  @param selectedImageName 选中的图标名
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    vc.tabBarItem.title = title;
    if (imageName.length) { // 图片名有具体值
        vc.tabBarItem.image = [UIImage imageNamed:imageName];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    }
    
    // 包装一个导航控制器， 添加导航控制器为tabBarController的子控制器
    JCBNavigationController *navigationC = [[JCBNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navigationC];
}


@end
