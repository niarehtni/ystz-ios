//
//  STCountDownButton.h
//  STCountDownButton
//
//  Created by on 16/2/14.
//  Copyright © 2016年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCountDownButton : UIButton

/** 设置秒数 */
@property (nonatomic, assign) NSInteger second; 

/** 开始倒计时 */
- (void)start;

/** 结束倒计时 */
- (void)stop;

@end
