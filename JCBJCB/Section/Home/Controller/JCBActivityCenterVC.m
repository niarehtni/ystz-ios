//
//  JCBActivityCenterVC.m
//  JCBJCB
//
//  Created by apple on 2016/10/18.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBActivityCenterVC.h"

@interface JCBActivityCenterVC () <UIWebViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JCBActivityCenterVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    self.view.backgroundColor = SGCommonBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubviews];
    // 获取数据
    [self getDataFromNetWorking];
    
}

- (void)getDataFromNetWorking {
    
    self.imageView.SG_y = - navigationAndStatusBarHeight;
    
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.imageView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@/rest/activity/%@", SGCommonURL, _content_id];
        [SGHttpTool getAll:urlStr params:nil success:^(id json) {
            SGDebugLog(@"%@", json);
            NSString *image_URL = json[@"activity"][@"content"];
            if ([image_URL isEqual:[NSNull null]]) {
                
            } else {
                
                [_imageView sd_setImageWithURL:[NSURL URLWithString:image_URL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    SGDebugLog(@"image - - - %@", image);
                    _imageView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenWidth * image.size.height/image.size.width);
                    _scrollView.contentSize = CGSizeMake(SG_screenWidth, navigationAndStatusBarHeight + SG_screenWidth * image.size.height/image.size.width);
                }];
            }

            self.view.SG_y = navigationAndStatusBarHeight;
            
            [MBProgressHUD SG_hideHUDForView:self.imageView];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD SG_hideHUDForView:self.imageView];
            SGDebugLog(@"%@", error);
        }];
    });
}

- (void)setupSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.frame;
    [self.view addSubview:_scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    _imageView.frame = _scrollView.frame;
    [_scrollView addSubview:_imageView];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
