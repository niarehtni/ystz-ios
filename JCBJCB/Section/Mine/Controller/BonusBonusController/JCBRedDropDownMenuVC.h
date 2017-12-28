//
//  JCBRedDropDownMenuVC.h
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBRedDropDownMenuVC;

@protocol JCBRedDropDownMenuVCDelegate <NSObject>

- (void)dismiss;

- (void)JCBRedDropDownMenuVC:(JCBRedDropDownMenuVC *)JCBRedDropDownMenuVC  index:(NSUInteger)index title:(NSString *)title;

@end

@interface JCBRedDropDownMenuVC : UIViewController
@property (nonatomic, assign) id<JCBRedDropDownMenuVCDelegate> delegate_dropDown;

@end
