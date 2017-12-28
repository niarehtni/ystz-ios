//
//  JCBInviteFriendsVC.m
//  JCBJCB
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBInviteFriendsVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "JCBNoBinViewFriendsTVCell.h"
#import "JCBBinviteFriendsTVCell.h"
#import "JCBInviteFriendsModel.h"

@interface JCBInviteFriendsVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *share_btn;
@property (nonatomic, strong) NSDictionary *dataSource_dic;
@property (nonatomic, strong) NSMutableArray *friend_dataSource_mArr;
@property (nonatomic, assign) NSUInteger firstPageNumber;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *allDataSourse;
@property (nonatomic, copy) NSString *noDataSourceText;
@end

@implementation JCBInviteFriendsVC

static CGFloat const cellHeightOf5s = 44;
static CGFloat const cellHeightOf6s = 46;
static CGFloat const cellHeightOf6P = 48;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"邀请好友";
    self.friend_dataSource_mArr = [NSMutableArray array];
    
    [self getDataFromNetWorking];
    
}


- (void)getDataFromNetWorking {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/friendsList", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json json - - -  %@", json);
        self.dataSource_dic = json;
        [self setupTopView];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"error - - -  %@", error);
    }];
}

#pragma mark - - - refresh
- (void)setupRefresh{
    self.tableView.mj_header = [SGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSourse)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [SGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSourse)];
}

- (void)loadNewDataSourse {
    
    self.tableView.mj_footer.hidden = YES;
    
    self.firstPageNumber = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/friendsList?pageNumber=%ld&pageSize=10", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"friendList - json - - -  %@", json);
        self.tableView.mj_footer.hidden = NO;

        self.dataSource_dic = json;
        self.friend_dataSource_mArr = [JCBInviteFriendsModel mj_objectArrayWithKeyValuesArray:json[@"friendList"]];

        //[self setupTopView];

        if (self.friend_dataSource_mArr.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            //self.tableView.hidden = YES;
        }
        
        int total = [json[@"pageBean"][@"totalCount"] intValue];
        if (self.friend_dataSource_mArr.count == total) {
            self.tableView.mj_footer.hidden = YES;
        }
        
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        self.noDataSourceText = @"您当前暂无邀请记录哦！";
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - -  %@", error);
        // 让[刷新控件]结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 数据加载失败隐藏刷新功能
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
    }];
    
}
- (void)loadMoreDataSourse {
    [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"加载中，请稍等" toView:self.view];
    self.firstPageNumber += 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/friendsList?pageNumber=%ld&pageSize=10", SGCommonURL, self.firstPageNumber];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"json - - -  %@", json);
        
        NSArray *moreDataSource = [JCBInviteFriendsModel mj_objectArrayWithKeyValuesArray:json[@"friendList"]];
        
        [self.friend_dataSource_mArr addObjectsFromArray:moreDataSource];
        
        [self.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD SG_hideHUDForView:self.view];
        SGDebugLog(@"error - - -  %@", error);
        // 让[刷新控件]结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 数据加载失败隐藏刷新功能
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
    }];
    
}

- (void)setupTopView {
    
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"jcb_inviteFriends_top_icon"];
    CGFloat topImageViewW = topImageView.image.size.width;
    CGFloat topImageViewH = topImageView.image.size.height;
    CGFloat topImageViewX = 0.5 * (SG_screenWidth - topImageViewW);
    CGFloat topImageViewY = 0;
    topImageView.frame = CGRectMake(topImageViewX, topImageViewY, topImageViewW, topImageViewH);
    [self.scrollView addSubview:topImageView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    NSString *contentStr = self.dataSource_dic[@"spreadTextarea"];
    topLabel.text = contentStr;
    topLabel.numberOfLines = 0;
    topLabel.textColor = SGColorWithRGB(174, 19, 0);
    topLabel.font = [UIFont systemFontOfSize:SGTextFontWith12];
    CGSize topLabelSize = [SGHelperTool SG_sizeWithText:contentStr font:[UIFont systemFontOfSize:SGTextFontWith12] maxSize:CGSizeMake(SG_screenWidth - 6 * SGMargin, MAXFLOAT)];
    CGFloat topLabelX = SGMargin;
    CGFloat topLabelY = SGMargin;
    CGFloat topLabelW = SG_screenWidth - 6 * topLabelX;
    CGFloat topLabelH = topLabelSize.height;
    topLabel.frame = CGRectMake(topLabelX, topLabelY, topLabelW, topLabelH);
    topLabel.backgroundColor = [UIColor clearColor];
    
    self.topView = [[UIView alloc] init];
    CGFloat topViewX = 2 * SGMargin;
    CGFloat topViewY = CGRectGetMaxY(topImageView.frame) + SGSmallMargin;
    CGFloat topViewW = SG_screenWidth - 2 * topViewX;
    CGFloat topViewH = topLabelH + 2 * SGMargin;
    _topView.frame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    _topView.backgroundColor = SGColorWithRGB(247, 229, 180);
    [self.scrollView addSubview:_topView];
    [SGSmallTool SG_smallWithThisView:_topView cornerRadius:5];

    [self.topView addSubview:topLabel];
    
    // 添加分享按钮
    [self setupShareButton];

    // 底部 View
    [self setupBottomView];
}

- (void)setupShareButton {
    self.share_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    CGFloat share_btnH = 0;
    if (iphone5s) {
        share_btnH = SGLoginBtnWithIphone5sHeight;
    } else if (iphone6s) {
        share_btnH = SGLoginBtnWithIphone6sHeight;
    } else if (iphone6P) {
        share_btnH = SGLoginBtnWithIphone6PHeight;
    }
    
    CGFloat share_btnX = 3 * SGMargin;
    CGFloat share_btnY = CGRectGetMaxY(self.topView.frame) + 2 * SGMargin;
    CGFloat share_btnW = SG_screenWidth - 2 * share_btnX;
    _share_btn.frame = CGRectMake(share_btnX, share_btnY, share_btnW, share_btnH);
    _share_btn.backgroundColor = SGColorWithRGB(245, 198, 82);
    [_share_btn setTitle:@"立即邀请" forState:(UIControlStateNormal)];
    [_share_btn setTitleColor:SGColorWithRGB(129, 62, 21) forState:(UIControlStateNormal)];
    [SGSmallTool SG_smallWithThisView:_share_btn cornerRadius:share_btnH * 0.5];
    [SGSmallTool SG_smallWithThisView:_share_btn borderWidth:1 borderColor:[UIColor blackColor]];
    [_share_btn addTarget:self action:@selector(share_btn_action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:_share_btn];
}

- (void)setupBottomView {
    CGFloat cellNumber = 5;

    CGFloat bottomViewH = 0;
    if (iphone5s) {
        bottomViewH = cellHeightOf5s * cellNumber + 1;
    } else if (iphone6s) {
        bottomViewH = cellHeightOf6s * cellNumber + 1;
    } else if (iphone6P) {
        bottomViewH = cellHeightOf6P * cellNumber + 1;
    }
    CGFloat bottomViewX = 2 * SGMargin;
    CGFloat bottomViewY = CGRectGetMaxY(self.share_btn.frame) + 2 * SGMargin;
    CGFloat bottomViewW = SG_screenWidth - 2 * bottomViewX;
    self.bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    _bottomView.backgroundColor = SGColorWithRGB(247, 229, 180);
    [SGSmallTool SG_smallWithThisView:_bottomView cornerRadius:5];
    [self.scrollView addSubview:_bottomView];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_bottomView.frame) + 3 * SGMargin);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = bottomViewW;
    CGFloat titleLabelH = 0;
    if (iphone5s) {
        titleLabelH = cellHeightOf5s;
    } else if (iphone6s) {
        titleLabelH = cellHeightOf6s;
    } else if (iphone6P) {
        titleLabelH = cellHeightOf6P;
    }
    //titleLabel.backgroundColor = SGColorWithRandom;
    titleLabel.text = @"邀请记录";
    titleLabel.font = [UIFont systemFontOfSize:SGTextFontWith15];
    titleLabel.textColor = SGColorWithRGB(129, 62, 21);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    [_bottomView addSubview:titleLabel];
    
#pragma mark - - - 分割线
    UIView *splitView = [[UIView alloc] init];
    splitView.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), bottomViewW, 1);
    splitView.backgroundColor = SGColorWithDarkGrey;
    [_bottomView addSubview:splitView];
    
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(splitView.frame);
    CGFloat tableViewW = bottomViewW;
    CGFloat tableViewH = bottomViewH - tableViewY;
    self.tableView = [[JCBTableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:(UITableViewStylePlain)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UITapGestureRecognizer *GR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOne)];
    GR.delegate = self;
    [self.tableView addGestureRecognizer:GR];
    
    if (iphone5s) {
        _tableView.rowHeight = cellHeightOf5s;
    } else if (iphone6s) {
        _tableView.rowHeight = cellHeightOf6s;
    } else if (iphone6P) {
        _tableView.rowHeight = cellHeightOf6P;
    }
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBNoBinViewFriendsTVCell class]) bundle:nil] forCellReuseIdentifier:@"noCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCBBinviteFriendsTVCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [_bottomView addSubview:_tableView];
    
    [self setupRefresh];
}

#pragma mark - - - 手势方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    self.scrollView.scrollEnabled = NO;
    // 截获Touch事件
    return  YES;
}

- (void)touchOne {
    self.scrollView.scrollEnabled = YES;
}

#pragma mark - - - tableView代理、数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friend_dataSource_mArr.count == 0) {
        return 1;
    } else {
        return self.friend_dataSource_mArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.friend_dataSource_mArr.count == 0) {
        JCBNoBinViewFriendsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.noDataLabel.text = self.noDataSourceText;
        return cell;
    } else {
        JCBBinviteFriendsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = SGColorWithRGB(247, 229, 180);
        JCBInviteFriendsModel *model = self.friend_dataSource_mArr[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollView.scrollEnabled = YES;
}

#pragma mark - - - 分享按钮的点击事件
- (void)share_btn_action {
    SGDebugLog(@"share_btn_action");
    
    // 显示分享面板
    __weak typeof(self) weakSelf = self;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWebPageToPlatformType:platformType];
    }];

}


#pragma mark - - - UMScial
// 网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    // 创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //NSString *thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.dataSource_dic[@"spreadText"] descr:self.dataSource_dic[@"spreadTextarea"] thumImage:[UIImage imageNamed:@"appIcon_share_icon"]];
    
    // 设置网页地址
    shareObject.webpageUrl = self.dataSource_dic[@"tgNo"];
    
    // 分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"分享失败：%@",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                // 分享结果消息
                UMSocialLogInfo(@"分享消息信息：%@",resp.message);
                // 第三方原始返回的数据
                UMSocialLogInfo(@"第三方原始返回的数据：%@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"恭喜您，分享成功"];
    } else {
        if (error) {
            result = [NSString stringWithFormat:@"分享失败原因: %d\n",(int)error.code];
        } else {
            result = [NSString stringWithFormat:@"很遗憾！您分享失败"];
        }
    }
    
    SGAlertView *alert = [[SGAlertView alloc] initWithTitle:@"主人" delegate:nil contentTitle:result alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];

    [alert show];
}



@end


