//
//  RedRightDropDownMenu.m
//  DropDownMenu
//
//  Created by Sorgle on 16/5/1.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "RedRightDropDownMenu.h"

@interface RedRightDropDownMenu()
/** 将来用来显示具体内容的容器 */
@property (nonatomic, weak) UIImageView *containerView;
@end

@implementation RedRightDropDownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        // 添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"mine_red_dropDown_white_icon"];
        containerView.userInteractionEnabled = YES; // 开启交互
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return self;
}


+ (instancetype)menu {
    return [[self alloc] init];
}

- (void)setContent:(UIView *)content{
    _content = content;
    
    // 调整内容的位置
    content.SG_x = 10;
    content.SG_y = 15;
    
    // 设置灰色的高度
    self.containerView.SG_height = CGRectGetMaxY(content.frame) + 11;
    // 设置灰色的宽度
    self.containerView.SG_width = CGRectGetMaxX(content.frame) + 10;
    
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController{
    _contentController = contentController;
    
    self.content = contentController.view;
}

/** 显示 */
- (void)showFrom:(UIView *)from{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    // 4.调整灰色图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    //    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.containerView.SG_centerX = CGRectGetMidX(newFrame) - self.containerView.SG_width / 2 + 23;
    self.containerView.SG_y = CGRectGetMaxY(newFrame);
    
    // 通知外界，自己显示了
    if ([self.delegate_dropDown respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate_dropDown dropdownMenuDidShow:self];
    }
}

/** 销毁 */
- (void)dismiss{
    [self removeFromSuperview];
    // 通知外界，自己被销毁了
    if ([self.delegate_dropDown respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate_dropDown dropdownMenuDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


@end
