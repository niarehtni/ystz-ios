//
//  JCBBingCardDropDownMenuVC.m
//  JCBJCB
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBBingCardDropDownMenuVC.h"
#import "RightDropDownMenu.h"
#import "JCBBingCardModel.h"

@interface JCBBingCardDropDownMenuVC () <UITableViewDelegate, UITableViewDataSource, RightDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource_arr;
@end

@implementation JCBBingCardDropDownMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self getDataSourceFromNetWorking];
}

- (void)getDataSourceFromNetWorking {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/bankTo", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool getAll:urlStr params:nil success:^(id json) {
        SGDebugLog(@"json - - - %@", json);
        self.dataSource_arr = [JCBBingCardModel mj_objectArrayWithKeyValuesArray:json[@"bankCardList"]];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SGDebugLog(@"json - - - %@", error);
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    JCBBingCardModel *model = self.dataSource_arr[indexPath.row];
    NSString *bankCardTypeStr = [NSString stringWithFormat:@"mine_bankCard_%@_icon", model.bankId];
    ; // mine_bankCard_GDB_icon
    cell.imageView.image = [UIImage imageNamed:bankCardTypeStr];
    cell.textLabel.text = model.bankName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
    
    UIImage *image = cell.imageView.image;
    NSString *title = cell.textLabel.text;
    
    if ([self.delegate_dropDown respondsToSelector:@selector(dismiss)]) {
        [self.delegate_dropDown dismiss];
    }

    JCBBingCardModel *model = self.dataSource_arr[indexPath.row];
    if ([self.delegate_dropDown respondsToSelector:@selector(JCBBingCardDropDownMenuVC:imageName:title:bankId:)]) {
        [self.delegate_dropDown JCBBingCardDropDownMenuVC:self imageName:image title:title bankId:model.bankId];
    }
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
