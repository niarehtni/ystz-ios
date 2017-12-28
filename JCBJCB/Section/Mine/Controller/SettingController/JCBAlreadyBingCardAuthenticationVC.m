//
//  JCBAlreadyBingCardAuthenticationVC.m
//  JCBJCB
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBAlreadyBingCardAuthenticationVC.h"

@interface JCBAlreadyBingCardAuthenticationVC ()
@property (weak, nonatomic) IBOutlet UIView *topBG_view;

@property (weak, nonatomic) IBOutlet UIImageView *bankCardTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankCardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankKakaNameLabel;

@property (weak, nonatomic) IBOutlet UIView *oneDot_view;
@property (weak, nonatomic) IBOutlet UIView *twoDot_view;
@property (weak, nonatomic) IBOutlet UIView *threeDot_view;
@property (weak, nonatomic) IBOutlet UIView *fourDot_view;
@property (weak, nonatomic) IBOutlet UIView *fiveDot_view;
@property (weak, nonatomic) IBOutlet UIView *sixDot_view;


@end

@implementation JCBAlreadyBingCardAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的银行卡";
    self.view.backgroundColor = SGCommonBgColor;
    [SGSmallTool SG_smallWithThisView:self.topBG_view cornerRadius:3];
    [SGSmallTool SG_smallWithThisView:self.oneDot_view cornerRadius:3];
    [SGSmallTool SG_smallWithThisView:self.twoDot_view cornerRadius:3];
    [SGSmallTool SG_smallWithThisView:self.threeDot_view cornerRadius:3];
    [SGSmallTool SG_smallWithThisView:self.fourDot_view cornerRadius:3];
    [SGSmallTool SG_smallWithThisView:self.fiveDot_view cornerRadius:3];
    [SGSmallTool SG_smallWithThisView:self.sixDot_view cornerRadius:3];

    [self getDataFromNetWorking];
}

- (void)getDataFromNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.navigationController.view];

    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/bankTo", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"json - - - %@", json);
        NSArray *bankCardList_arr = json[@"bankCardList"];
        for (NSDictionary *dic in bankCardList_arr) {
            if ([dic[@"bankId"] isEqualToString:json[@"bankId"]]) {
                self.bankCardTypeLabel.text = dic[@"bankName"];
                NSString *bankCardTypeStr = [NSString stringWithFormat:@"mine_bankCard_%@_icon", dic[@"bankId"]];
                self.bankCardTypeImageView.image = [UIImage imageNamed:bankCardTypeStr];
            }
        }
        NSString *cardNo = json[@"cardNo"];
        cardNo = [cardNo SG_replaceCharcterInRange:NSMakeRange(0, cardNo.length - 4) withCharcter:@"**** **** **** "];
        self.bankCardNumLabel.text = cardNo;
        self.bankKakaNameLabel.text = json[@"realName"];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.navigationController.view];
        SGDebugLog(@"error - - - %@", error);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"加载失败" toView:self.view];
        });
    }];


}



@end
