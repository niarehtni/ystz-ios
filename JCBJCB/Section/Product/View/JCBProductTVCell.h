//
//  JCBProductTVCell.h
//  JCBJCB
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBProductModel;

@interface JCBProductTVCell : UITableViewCell
/** name */
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *timeType_label;
/** newpeople */
@property (weak, nonatomic) IBOutlet UIImageView *noviceSign_imageV;

/** baseApr */
@property (weak, nonatomic) IBOutlet UILabel *baseApr_label;
/** awardApr */
@property (weak, nonatomic) IBOutlet UIButton *awardApr_btn;
/** timeLimit */
@property (weak, nonatomic) IBOutlet UILabel *timeLimit_label;
/** lowestAccount */
@property (weak, nonatomic) IBOutlet UILabel *purchaseAmount_label;
/** schedule */
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView;



@property (nonatomic, strong) JCBProductModel *model;
@end
