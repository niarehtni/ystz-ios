//
//  SGGesturePasswordView.m
//  SG_GesturePassword
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SGGesturePasswordView.h"
/****** 屏幕尺寸 ******/
#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height

#define iphone6P (SG_screenHeight == 736)
#define iphone6s (SG_screenHeight == 667)
#define iphone5s (SG_screenHeight == 568)
#define iphone4s (SG_screenHeight == 480)

@interface SGGesturePasswordView ()
@property (nonatomic, strong) NSMutableArray *selectBtn_mArr;

@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation SGGesturePasswordView

static NSInteger const buttonCount = 9;

- (NSMutableArray *)selectBtn_mArr {
    if (!_selectBtn_mArr) {
        _selectBtn_mArr = [NSMutableArray array];
    }
    return _selectBtn_mArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupAllButton];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 初始化按钮
        [self setupAllButton];
        self.backgroundColor = SGColorWithClear;
    }
    return self;
}

+ (instancetype)gesturePasswordViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (void)setupAllButton {
    
    for (int i = 0; i < buttonCount; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}


// 手指开始点击
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint curPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:curPoint];
    if (btn) {
        btn.selected = YES;
        [self.selectBtn_mArr addObject:btn];
    }
}

// 获取当前手指所在的点
- (CGPoint)getCurrentPoint:(NSSet *)touches{
    
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

// 判断当前手指在不在按钮上
- (UIButton *)btnRectContainsPoint:(CGPoint)point{
    
    for (UIButton *btn in self.subviews) {
        // 判断一个点在不在某个区域当中
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    
    return nil;
}

// 手指移动的时候调用
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 获取当前手指所在的点
    self.currentPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:_currentPoint];
    if (btn && btn.selected == NO){
        btn.selected = YES;
        [self.selectBtn_mArr addObject:btn];
    }
    [self setNeedsDisplay];
}

// 手指离开屏幕时调用
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSMutableArray *tempMArr = [NSMutableArray array];
    // 取消选中按钮选中状态
    for (UIButton *btn in self.selectBtn_mArr) {
        btn.selected = NO;
        NSString *selected_button = [NSString stringWithFormat:@"%zd", btn.tag];
        [tempMArr addObject:selected_button];
    }
    //NSString *temp_str = [tempMArr componentsJoinedByString:@","];
    
    // 注册通知，监听手势密码的变化
    [SGNotificationCenter postNotificationName:@"selectedButtonArray" object:tempMArr];
    [SGNotificationCenter postNotificationName:@"reviseGesturePassword" object:tempMArr];
    [SGNotificationCenter postNotificationName:@"unlockGesturePassword" object:tempMArr];

    // 清空路径
    [self.selectBtn_mArr removeAllObjects];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.selectBtn_mArr.count <= 0) {
        return;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    for (int i = 0; i < self.selectBtn_mArr.count; i++){
        
        UIButton *btn = self.selectBtn_mArr[i];
        if (i == 0) {
            [bezierPath moveToPoint:btn.center];
        } else {
            [bezierPath addLineToPoint:btn.center];
        }
    }
    
    [bezierPath addLineToPoint:self.currentPoint];
    
    [[UIColor colorWithRed:21/255.0 green:82/255.0 blue:255/255.0 alpha:0.6] set];
    [bezierPath setLineWidth:2];
    [bezierPath setLineJoinStyle:kCGLineJoinRound];
    [bezierPath stroke];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // button列数
    int column = 3;
    // button距离父视图的间距
    CGFloat toSuperViewMargin = 5;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat buttonWH = 0;
    if (iphone4s || iphone5s) {
        buttonWH = 54;
    } else if (iphone6s) {
        buttonWH = 64;
    } else if (iphone6P) {
        buttonWH = 74;
    }
    
    // button之间的间距
    CGFloat margin = (self.bounds.size.width - buttonWH * column - 2 * toSuperViewMargin) / (column - 1);
    
    for (int i = 0; i < self.subviews.count; i++) {
        
        int currentColumn = i % column;
        int currentRow = i / column;

        x = toSuperViewMargin + currentColumn * (buttonWH + margin);
        y = toSuperViewMargin + currentRow * (buttonWH + margin);
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, buttonWH, buttonWH);
    }
}


@end

