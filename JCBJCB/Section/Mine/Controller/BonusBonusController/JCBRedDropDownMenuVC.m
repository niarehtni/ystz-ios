//
//  JCBRedDropDownMenuVC.m
//  JCBJCB
//
//  Created by apple on 16/11/2.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBRedDropDownMenuVC.h"

@interface JCBRedDropDownMenuVC () <UITableViewDelegate, UITableViewDataSource, RedRightDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource_arr;

@end

@implementation JCBRedDropDownMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor clearColor];
    self.dataSource_arr = @[@"未使用", @"已使用", @"已过期"];
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
    //cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataSource_arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell时有背景颜色效果，返回后背景颜色效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = UITableViewCellSelectionStyleNone;
        
    if ([self.delegate_dropDown respondsToSelector:@selector(dismiss)]) {
        [self.delegate_dropDown dismiss];
    }
    
    if ([self.delegate_dropDown respondsToSelector:@selector(JCBRedDropDownMenuVC:index:title:)]) {
        [self.delegate_dropDown JCBRedDropDownMenuVC:self index:indexPath.row title:self.dataSource_arr[indexPath.row]];
    }
}

//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //self.tableView.backgroundColor = [UIColor clearColor];
    //cell.contentView.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor clearColor];
}

@end
