//
//  DOPDropDownMenu.h
//  DOPDropDownMenuDemo
//
//  Created by weizhou on 9/26/14.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DOPIndexPath : NSObject
/** 列数 */
@property (nonatomic, assign) NSInteger column;
/** 行数 */
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;

@end


#pragma mark - - - DOPDropDownMenu的数据源方法
@class DOPDropDownMenu;
@protocol DOPDropDownMenuDataSource <NSObject>
@required
/** 每列多少行（默认是一） */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column;
/** 菜单每列的标题（默认是一） */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath;
@optional
/** 总共多少列（默认是一） */
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu;

@end

#pragma mark - - - DOPDropDownMenu的代理方法
@protocol DOPDropDownMenuDelegate <NSObject>
@optional
/** 点击每列的代理方法 */
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath;
@end

#pragma mark - - - DOPDropDownMenu的（interface）
@interface DOPDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <DOPDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <DOPDropDownMenuDelegate> delegate;
/** 指示器颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  菜单的宽度将设置为屏幕宽度defaultly
 *  @param height menu's height（菜单的高度）
 *  @return menu
 */

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
/** 菜单上选择的标题 */
- (NSString *)titleForRowAtIndexPath:(DOPIndexPath *)indexPath;

@end


