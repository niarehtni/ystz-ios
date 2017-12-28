//
//  JCBProductRedTVCell.h
//  JCBJCB
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBProductRedModel;

@interface JCBProductRedTVCell : UITableViewCell
@property (nonatomic , strong) UIButton *selectedBtn;
@property (nonatomic, strong) JCBProductRedModel *model;
@property (nonatomic, strong) JCBProductRedModel *unUseModel;
@end
