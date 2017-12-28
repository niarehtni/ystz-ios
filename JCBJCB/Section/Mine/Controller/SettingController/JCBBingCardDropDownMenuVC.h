//
//  JCBBingCardDropDownMenuVC.h
//  JCBJCB
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCBBingCardDropDownMenuVC;

@protocol JCBBingCardDropDownMenuVCDelegate <NSObject>

- (void)dismiss;

- (void)JCBBingCardDropDownMenuVC:(JCBBingCardDropDownMenuVC *)JCBBingCardDropDownMenuVC imageName:(UIImage *)imageName title:(NSString *)title bankId:(NSString *)bankId;

@end

@interface JCBBingCardDropDownMenuVC : UIViewController
@property (nonatomic, assign) id<JCBBingCardDropDownMenuVCDelegate> delegate_dropDown;
@end
