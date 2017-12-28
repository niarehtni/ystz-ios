//
//  SGFourTableViewCell.h
//  RongXunTechnology
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 RongXun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBFourCellModel;

@interface SGFourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dot_view;
@property (weak, nonatomic) IBOutlet UIButton *pushProductVCBtn;
/** name */
@property (weak, nonatomic) IBOutlet UILabel *name_label;
/** 收益 */
@property (weak, nonatomic) IBOutlet UILabel *baseApr_label;
/** 新手加送 */
@property (weak, nonatomic) IBOutlet UIButton *awardApr_label;
/** 投资天数 */
@property (weak, nonatomic) IBOutlet UILabel *timeLimit_label;
/** 总金额 */
@property (weak, nonatomic) IBOutlet UILabel *account_label;
/** 剩余金额 */
@property (weak, nonatomic) IBOutlet UILabel *balance_Label;

@property (nonatomic, strong) JCBFourCellModel *model;

@end
