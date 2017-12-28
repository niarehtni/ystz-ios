//
//  JCBNoDataView.m
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBNoDataView.h"

@implementation JCBNoDataView

+ (instancetype)noDataView {
    return [[[NSBundle mainBundle] loadNibNamed:@"JCBNoDataView" owner:nil options:nil] firstObject];
}

@end
