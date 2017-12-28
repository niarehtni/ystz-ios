//
//  JCBCMBHTML5VC.m
//  JCBJCB
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBCMBHTML5VC.h"
#import "JCBRongBaoPayVC.h"

@interface JCBCMBHTML5VC () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JCBCMBHTML5VC

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SGHttpTool getHTML:self.url_Str params:nil success:^(id dictionary) {
        SGDebugLog(@"dictionary - - %@", dictionary);

    } failure:^(NSError *error) {
        SGDebugLog(@"error - - %@", error);
    }];
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - navigationAndStatusBarHeight)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url_Str]]];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD SG_hideHUDForView:self.view];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 获取此时的URL
    NSURL *url = [request URL];
    NSString *current_url = [url absoluteString];
    SGDebugLog(@"current_url - - - %@", current_url);
    
    // 第一步:检测链接中的 km_ 特殊字段
    NSString *have_str = @"km_";
    NSRange jumpRange = [current_url rangeOfString:have_str];
    
    if (jumpRange.location != NSNotFound) { // 包含
        // 第二步:再次检测链接中的 km_success 特殊字段
        NSString *have_accurate_str = @"km_success";
        NSRange jumpRange_accurate = [current_url rangeOfString:have_accurate_str];

        if (jumpRange_accurate.location != NSNotFound) { // 支付成功
            SGDebugLog(@"招商支付成功");
            SGDebugLog(@"current_url 成功 - - - %@", current_url);
            NSInteger order_length = 16;
            NSString *order_num = [current_url substringWithRange:NSMakeRange(current_url.length - order_length, order_length)];
            SGDebugLog(@"order_num - - %@", order_num);
            [JCBSingletonManager sharedSingletonManager].isMBHTML5VCToRongBaoPayVC = YES;
            
            JCBRongBaoPayVC *rongBaoPayVC = [[JCBRongBaoPayVC alloc] init];
            rongBaoPayVC.user_order_no = order_num;
            [self.navigationController pushViewController:rongBaoPayVC animated:YES];
        } else { // 支付失败
            SGDebugLog(@"招商支付失败");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

    return YES;
}



@end
