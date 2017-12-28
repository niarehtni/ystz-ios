//
//  JCBMineOneTVCell.h
//  JCBJCB
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBMineModel;

@interface JCBMineOneTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
    
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic, strong) JCBMineModel *model;

@end
