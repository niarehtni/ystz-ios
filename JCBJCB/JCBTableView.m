//
//  JCBTableView.m
//  yueshangdai
//
//  Created by 黄浚 on 2017/9/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBTableView.h"

@implementation JCBTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
           // self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
         //   self.contentInsetAdjustmentBehavior =;
//            self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//            self.scrollIndicatorInsets = self.contentInset;
        }
    };
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
         //   self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//            self.scrollIndicatorInsets = self.contentInset;
        }
    }
    return self;
}
//@available(iOS 11.0, *)
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
          //  self.estimatedSectionFooterHeight = 0;
         //   self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//            self.scrollIndicatorInsets = self.contentInset;
        }
    }
    return self;
}

@end
