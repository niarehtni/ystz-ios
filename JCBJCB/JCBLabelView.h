//
//  JCBLabelView.h
//  yueshangdai
//
//  Created by 黄浚 on 2017/9/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCBLabelView : UIView
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UILabel *leftLabel;
@property (nonatomic ,strong) UIButton *button;
+ (instancetype)labelViewWithWithName:(NSString *)name;
@end
