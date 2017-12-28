//
//  SGTextField.m
//  JCBJCB
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGTextField.h"

@implementation SGTextField

/** 控制placeHolder的位置, 根据placeholderLabelFont的字体大小而定 */
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 1, bounds.origin.y + 7, bounds.size.width - 2, bounds.size.height);
}


@end
