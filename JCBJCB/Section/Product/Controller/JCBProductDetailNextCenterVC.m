//
//  JCBProductDetailNextCenterVC.m
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBProductDetailNextCenterVC.h"
#import "JCBDatumModel.h"

@interface JCBProductDetailNextCenterVC ()
@property (nonatomic, strong) UIScrollView *bg_scrollView;
@property (nonatomic, strong) NSMutableArray *url_image_mArr;
@property (nonatomic, strong) PYPhotosView *photosView;

@end

@implementation JCBProductDetailNextCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = SGCommonBgColor;
    
    [self setupBGScrollView];
    
    // 获取数据
    [self getDataFromNetWorking];
}

- (void)setupBGScrollView {
    self.bg_scrollView = [[UIScrollView alloc] init];
    _bg_scrollView.frame = CGRectMake(0, 0, SG_screenWidth, SG_screenHeight - navigationAndStatusBarHeight - cellDeautifulHeight);
    _bg_scrollView.backgroundColor = SGCommonBgColor;
    [self.view addSubview:_bg_scrollView];
}

- (void)getDataFromNetWorking {
    self.url_image_mArr = [NSMutableArray array];
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/borrow/%@", SGCommonURL, self.idStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"json - - - %@", json);
        [MBProgressHUD SG_hideHUDForView:self.view];

       NSArray *image_arr = [JCBDatumModel mj_objectArrayWithKeyValuesArray:json[@"borImage"]];
        for (int i = 0; i < image_arr.count; i++) {
            JCBDatumModel *model = image_arr[i];
            NSString *urlStr = [NSString stringWithFormat:@"%@/mobile%@", SGCommonImageURL, model.url];
            [self.url_image_mArr addObject:urlStr];
            
            SGDebugLog(@"url_image_mArr - - - %@", self.url_image_mArr);
        }
        
        // 创建PYPhotoView
        [self setupPYPhotoView];
        
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        
        SGDebugLog(@"%@", error);
    }];
}


- (void)setupPYPhotoView {
    // 创建一个流水布局photosView(默认为流水布局)
    self.photosView = [PYPhotosView photosView];
    
    // 设置分页指示类型
    _photosView.pageType = PYPhotosViewPageTypeLabel;
    // 设置缩略图数组
    _photosView.thumbnailUrls = self.url_image_mArr;
    // 设置原图地址
    _photosView.originalUrls = self.url_image_mArr;
    _photosView.photosMaxCol = 2;
    _photosView.photoMargin = 10;
    _photosView.py_x = 10;
    _photosView.py_y = 2 * SGMargin;
    _photosView.photoWidth = (SG_screenWidth - 3 * SGMargin) * 0.5;
    _photosView.photoHeight = _photosView.photoWidth * 0.7;

    [self.bg_scrollView addSubview:_photosView];
    _bg_scrollView.contentSize = CGSizeMake(SG_screenWidth, CGRectGetMaxY(_photosView.subviews.lastObject.frame) + 5 * SGMargin);
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
