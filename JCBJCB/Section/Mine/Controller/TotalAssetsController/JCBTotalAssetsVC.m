//
//  JCBTotalAssetsVC.m
//  JCBJCB
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "JCBTotalAssetsVC.h"
#import "JCBNounInterpretationVC.h"

@interface JCBTotalAssetsVC ()

@end

@implementation JCBTotalAssetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"总资产";
    self.view.backgroundColor = SGCommonBgColor;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction) image:@"mine_totalAssets_navigationBar_icon" highImage:@""];
}
    
- (void)rightBarButtonItemAction {
    JCBNounInterpretationVC *NIVC = [[JCBNounInterpretationVC alloc] init];
    [self.navigationController pushViewController:NIVC animated:YES];
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
