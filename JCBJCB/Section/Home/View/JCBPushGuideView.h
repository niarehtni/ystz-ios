//
//  JCBPushGuideView.h
//  JCBJCB
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCBPushGuideView : UIView

@property(nonatomic,strong) UINavigationController *bridgeNavigationC;
@property (nonatomic, strong) NSDictionary *pushGuide_dic;
+ (instancetype)JCBPushGuideViewWithFrame:(CGRect)frame;

@end
