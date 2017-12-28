//
//  SGOneTableViewCell.h
//  JCBJCB
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGOneTableViewCell;

@protocol SGOneTableViewCellDelegate <NSObject>

- (void)oneTableViewCell:(SGOneTableViewCell *)oneTableViewCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface SGOneTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *URLWithImage;
@property (nonatomic, assign)  id<SGOneTableViewCellDelegate> delegate;

@end
