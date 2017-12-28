//
//  JCBMineTopTVCell.h
//  JCBJCB
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBMineModel;

@interface JCBMineTopTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) JCBMineModel *model;

@end
