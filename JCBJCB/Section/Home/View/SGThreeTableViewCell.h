//
//  SGThreeTableViewCell.h
//  RongXunTechnology
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 RongXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGThreeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *left_imageView;
@property (nonatomic, strong) UIView *bg_view;
@property (nonatomic, strong) UIButton *detail_btn;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *activityTime_label;
@property (nonatomic, strong) UIImageView *smallIcon_imageView;
@end
