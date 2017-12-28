//
//  JCBCustomerServiceVC.m
//  JCBJCB
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBCustomerServiceVC.h"
#import "MQChatViewManager.h"

@interface JCBCustomerServiceVC ()
@property (nonatomic, strong) NSDictionary *userCenter_dict;

@end

@implementation JCBCustomerServiceVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userCenter", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"userCenter - json - - - %@", json);
        self.userCenter_dict = json;
        
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - - %@", error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客户服务";
    self.view.backgroundColor = SGCommonBgColor;
    
}


- (IBAction)onlineService_action:(id)sender {
    //屏蔽美洽客服
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"功能稍后上线" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
    
    
    // 初始化MQChatViewManager
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setChatViewStyle:[MQChatViewStyle blueStyle]];

    // 用户绑卡状态
    NSString *realStatus = [NSString stringWithFormat:@"%@", self.userCenter_dict[@"realStatus"]];
    
    if ([self.userCenter_dict[@"rcd"] isEqualToString:@"R0001"]) { // 用户已经登录成功了
        if ([realStatus isEqualToString:@"1"]) { // 用户已绑定过银行卡
            // 获取用户信息
            NSDictionary *VIP_user = @{@"name" : self.userCenter_dict[@"realName"], @"tel" : self.userCenter_dict[@"username"]};
            [chatViewManager setClientInfo:VIP_user override:YES];

        } else {  // 用户未进行银行卡绑定
            // 获取用户信息
            NSDictionary *user = @{@"name" : @"注册用户", @"tel" : self.userCenter_dict[@"username"]};
            [chatViewManager setClientInfo:user override:YES];
        }
    } else { // 用户并没有登录
        //[chatViewManager setLoginMQClientId:@"0"];
        // 获取用户信息
        NSDictionary *visitor = @{@"name" : @"游客", @"tel" : @""};
        [chatViewManager setClientInfo:visitor override:YES];
        SGDebugLog(@"visitor - - %@", visitor);
        // 开启同步消息
        //[chatViewManager enableSyncServerMessage:true];
    }
    
    [chatViewManager pushMQChatViewControllerInViewController:self];
     
}

// 热线电话
- (IBAction)hotline_action:(id)sender {
    // 联系客服
    UIWebView *phoneNum = [[UIWebView alloc] init];
    phoneNum.frame = CGRectZero;
    NSURL *url = [NSURL URLWithString:@"tel://4000577820"];
    [phoneNum loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:phoneNum];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
