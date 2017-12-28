//
//  JCBLabelView.m
//  yueshangdai
//
//  Created by 黄浚 on 2017/9/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBLabelView.h"

@implementation JCBLabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        CGFloat one_viewX = 0;
        CGFloat one_viewY = 0;
        CGFloat one_viewW = SG_screenWidth;
        CGFloat one_viewH = 50;
        self.frame = CGRectMake(one_viewX, one_viewY, one_viewW, one_viewH);
    }
    return self;
}



- (void)loadLabel:(NSString *)name{
    self.backgroundColor = [UIColor whiteColor];
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.text = name;
    self.leftLabel.backgroundColor = [UIColor whiteColor];
    self.leftLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    [self.leftLabel sizeToFit];
    self.leftLabel.frame = CGRectMake(SGMargin, (self.frame.size.height - self.leftLabel.frame.size.height)/2, self.leftLabel.frame.size.width, self.leftLabel.frame.size.height);
    [self addSubview:self.leftLabel];
    self.textField = [[UITextField alloc] init];
    CGFloat nameTFX = CGRectGetMaxX(self.leftLabel.frame) + SGMargin;
    CGFloat nameTFW = SG_screenWidth - nameTFX - SGMargin;
    CGFloat nameTFH = 20;
    CGFloat nameTFY = (self.frame.size.height - nameTFH) * 0.5;
    self.textField.font = [UIFont systemFontOfSize:SGTextFontWith12];
    self.textField.frame = CGRectMake(nameTFX, nameTFY, nameTFW, nameTFH);
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:self.textField];
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_button setTitle:@"" forState:(UIControlStateNormal)];
//        _button.backgroundColor = SGColorWithRed;
        [_button setContentEdgeInsets:UIEdgeInsetsMake(8, 15, 8, 15)];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        [SGSmallTool SG_smallWithThisView:_button cornerRadius:5];
        [self addSubview:_button];
        __weak typeof(self) ws = self;
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.mas_centerY);
            make.left.equalTo(ws.leftLabel.mas_right).offset(SGMargin);
            make.right.equalTo(ws.button.mas_left).offset(-SGMargin);
        }];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.mas_centerY);
            make.right.equalTo(ws.mas_right).offset(-SGMargin);
//            make.height.mas_equalTo(34);
        }];
        
    }
    return _button;
}


- (void)addmas{
    __weak typeof(self) ws = self;
    //抗挤压
//    [self.leftLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    //抗拉伸
    [self.leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.mas_centerY);
        make.left.equalTo(ws.mas_left).offset(SGMargin);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.mas_centerY);
        make.left.equalTo(ws.leftLabel.mas_right).offset(SGMargin);
        make.right.equalTo(ws.mas_right);
    }];
}

+ (instancetype)labelViewWithWithName:(NSString *)name{
    JCBLabelView *view = [[JCBLabelView alloc] initWithName:name];
    [view loadLabel:name];
    [view addmas];
    return view;
}
@end
