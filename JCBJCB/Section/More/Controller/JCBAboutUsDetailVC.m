//
//  JCBAboutUsDetailVC.m
//  JCBJCB
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBAboutUsDetailVC.h"

@interface JCBAboutUsDetailVC () <UIWebViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JCBAboutUsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.content_title;
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubviews];
    // 获取数据
    [self getDataFromNetWorking];
}

- (void)getDataFromNetWorking {
    self.webView.SG_y = - navigationAndStatusBarHeight; // 这里的高度是为了让 MBProgressHUD 居中
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.webView];

    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/article/%@", SGCommonURL, _content_id];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"%@", json);
        [_webView loadHTMLString:json[@"content"] baseURL:nil];
        [MBProgressHUD SG_hideHUDForView:self.webView];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.webView];
        SGDebugLog(@"%@", error);
    }];
}

- (void)setupSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.frame;
    [self.view addSubview:_scrollView];
    
    self.webView = [[UIWebView alloc] init];
    _webView.frame = _scrollView.frame;
    _webView.delegate = self;
    [_scrollView addSubview:_webView];
}

/** webView完成加载 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 调整字号
    NSString *str1 = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str1];
    
    NSString *str = [NSString stringWithFormat:@"var script = document.createElement('script');"
                      "script.type = 'text/javascript';"
                      "script.text = \"function ResizeImages() { "
                      "var myimg,oldwidth;"
                      "var maxwidth = %f;" // UIWebView中显示的图片宽度
                      "for(i=0;i <document.images.length;i++){"
                      "myimg = document.images[i];"
                      "if(myimg.width > maxwidth){"
                      "oldwidth = myimg.width;"
                      "myimg.width = maxwidth;"
                      "}"
                      "}"
                      "}\";"
                      "document.getElementsByTagName('head')[0].appendChild(script);", SG_screenWidth - 20];
    [webView stringByEvaluatingJavaScriptFromString:str];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] intValue];
    _webView.SG_y = 0; // 恢复 webView 的 y 值
    _webView.SG_height = height;
    _scrollView.contentSize = CGSizeMake(SG_screenWidth, height + navigationAndStatusBarHeight);
}



@end

