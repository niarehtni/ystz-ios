//
//  DOPDropDownMenu.m
//  DOPDropDownMenuDemo
//
//  Created by weizhou on 9/26/14.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

#import "DOPDropDownMenu.h"
#import "DOPDropDownMenuTVCell.h"

@implementation DOPIndexPath
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    if (self = [super init]) {
        _column = column;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row {
    DOPIndexPath *indexPath = [[self alloc] initWithColumn:column row:row];
    return indexPath;
}
@end


#pragma mark - - - DOPDropDownMenu /@interface /@implementation
@interface DOPDropDownMenu ()
/** 当前选中菜单的下标 */
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
/** 是否展示 */
@property (nonatomic, assign) BOOL show;
/** 菜单数(列数) */
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
/** View的背景色 */
@property (nonatomic, strong) UIView *backGroundView;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
/** 指示器数 */
@property (nonatomic, copy) NSArray *indicators;
/** row的背景色 */
@property (nonatomic, copy) NSArray *bgLayers;
@end


@implementation DOPDropDownMenu
#pragma mark - getter
/** 设置指示器的颜色 */
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}
/** 设置字体的颜色 */
- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}
/** 设置分割线的颜色 */
- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}
/** 返回顶部标题文字 */
- (NSString *)titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

#pragma mark - setter
- (void)setDataSource:(id<DOPDropDownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    //configure view （配置View）
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else { // 默认返回一列
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    // CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
#pragma mark - - - 创建topView的内容
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        // 程序一启动时顶部View背景色和位置
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        // title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString = [_dataSource menu:self titleForRowAtIndexPath:[DOPIndexPath indexPathWithColumn:i row:0]];
        // 顶部title文字的颜色
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        
        // indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2 + 2)];
        [self.layer addSublayer:indicator];
        
        [tempIndicators addObject:indicator];
        // separator
        
        /*
         // 标题之间的分割线
            if (i != _numOfMenu - 1) {
                CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
                CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
                [self.layer addSublayer:separator];
            }
         
        */
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        
        //tableView init
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0) style:UITableViewStylePlain];
        _tableView.rowHeight = 44; // 设置每行的高度
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 注册
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DOPDropDownMenuTVCell class]) bundle:nil] forCellReuseIdentifier:@"DOPDropDownMenuTVCell"];

#pragma mark - - - 修改了顶部标题背景色颜色
        //self tapped
        self.backgroundColor = [UIColor lightGrayColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        
        // view的背景色
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        // backgroundTapped事件
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomShadow];
    }
    return self;
}

#pragma mark - - - init support  程序一启动时顶部View背景色和位置
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height - 1);
    layer.backgroundColor = color.CGColor;
    return layer;
}
#pragma mark - - - init support  Indicator
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
#pragma mark - - - 指示器样式
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(6, 6)];
    [path addLineToPoint:CGPointMake(12, 0)];
    //[path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
#pragma mark - - - 修改指示器颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}
#pragma mark - - - init support  SeparatorLine
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;

    return layer;
}
#pragma mark - - - 顶部title文字的颜色
- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    // 设置顶部label的文字大小以及间距
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}
// 设置顶部label的文字大小以及间距
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
            // 选中时其他顶部菜单的View的背景色
            [(CALayer *)self.bgLayers[i] setBackgroundColor:[UIColor whiteColor].CGColor];
        }
    }
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
        // 选中结束时选中的顶部菜单的View的背景色
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    } else {
        _currentSelectedMenudIndex = tapIndex;
        [_tableView reloadData];
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
            _show = YES;
        }];
        
        // 选中时选中的顶部菜单的View的背景色
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
    }
}
#pragma mark - - - backgroundTapped事件
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender {
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    // 选中背景View结束时， 点击的哪一列， 哪一列需要改变的颜色
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
}

#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];

#pragma mark - - - 判断指示器是否展开以及展开后的颜色
    if (forward) {
        indicator.fillColor = [UIColor clearColor].CGColor;
        
        indicator.strokeColor = [UIColor redColor].CGColor;
    } else {
        indicator.fillColor = [UIColor clearColor].CGColor;
        
        indicator.strokeColor = [UIColor blackColor].CGColor;
    }
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
        [self.superview addSubview:tableView];

#pragma mark - - - 超过 7 行时， tableView 显示 7 行， 且能够滚动
        CGFloat tableViewHeight = ([tableView numberOfRowsInSection:0] > 7) ? (7 * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
#pragma mark - - - 在这里设置tableView与顶部View之间的间距
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height + 1, self.frame.size.width, tableViewHeight);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
        }];
    }
    complete();
}

#pragma mark - - - 设置顶部标题的frame
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
#pragma mark - - - 添加了选中时标题的字体颜色
    if (!show) {
        title.foregroundColor = [UIColor blackColor].CGColor;
    } else {
        title.foregroundColor = [UIColor redColor].CGColor;

    }
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}

#pragma mark - - - table datasource 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:)]) {
        return [self.dataSource menu:self
                numberOfRowsInColumn:self.currentSelectedMenudIndex];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DOPDropDownMenuTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DOPDropDownMenuTVCell"];
    NSAssert(self.dataSource != nil, @"menu's datasource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        cell.titleLebel.text = [self.dataSource menu:self titleForRowAtIndexPath:[DOPIndexPath indexPathWithColumn:self.currentSelectedMenudIndex row:indexPath.row]];
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLebel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.titleLebel.textColor = [UIColor blackColor];
    cell.selectedImage.hidden = YES;
    if (cell.titleLebel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        cell.selectedImage.hidden = NO;
        cell.titleLebel.textColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - - - tableview delegate 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self confiMenuWithSelectRow:indexPath.row];
        [self.delegate menu:self didSelectRowAtIndexPath:[DOPIndexPath indexPathWithColumn:self.currentSelectedMenudIndex row:indexPath.row]];
    } else {
        //TODO: delegate is nil
    }
}

- (void)confiMenuWithSelectRow:(NSInteger)row {
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self.dataSource menu:self titleForRowAtIndexPath:[DOPIndexPath indexPathWithColumn:self.currentSelectedMenudIndex row:row]];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}


@end


