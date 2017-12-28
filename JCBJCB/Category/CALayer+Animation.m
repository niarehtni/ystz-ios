//
//  CALayer+Animation.m
//  JCBJCB
//
//  Created by apple on 17/1/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "CALayer+Animation.h"

@implementation CALayer (Animation)
- (void)SG_textShake {
    CAKeyframeAnimation *KFA = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat s = 5;
    KFA.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    // 时长
    KFA.duration = 0.3f;
    // 重复
    KFA.repeatCount = 2;
    // 移除
    KFA.removedOnCompletion = YES;
    
    [self addAnimation:KFA forKey:@"shake"];
}


@end
