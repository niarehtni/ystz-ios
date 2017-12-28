//
//  JCBPayBackTVCell.h
//  JCBJCB
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBPayBackModel;

@interface JCBPayBackTVCell : UITableViewCell
@property (nonatomic, strong) JCBPayBackModel *model;
@property (nonatomic, strong) JCBPayBackModel *backModel;

@end
