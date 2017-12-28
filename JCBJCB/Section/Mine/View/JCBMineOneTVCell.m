//
//  JCBMineOneTVCell.m
//  JCBJCB
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "JCBMineOneTVCell.h"
#import "JCBMineModel.h"

@implementation JCBMineOneTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self getDataFromeNetWorking];
}

- (void)getDataFromeNetWorking {
    /*
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/userNowIncome", SGCommonURL];
    urlStr = [urlStr SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr];
    
    [SGHttpTool postAll:urlStr params:nil success:^(id dictionary) {
        SGDebugLog(@"userNowIncome - dictionary - - %@", dictionary);
        self.rightLabel.text = dictionary[@"userNowIncome"];
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - %@", error);
    }];
    */

    NSString *urlStr_two = [NSString stringWithFormat:@"%@/rest/ajaxIndex", SGCommonURL];
    urlStr_two = [urlStr_two SG_thisEngineeringAnalyticalDateNeedMosaicTokenURLString:urlStr_two];
    
    [SGHttpTool postAll:urlStr_two params:nil success:^(id dictionary) {
        SGDebugLog(@"ajaxIndex - dictionary - - %@", dictionary);
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f", [dictionary[@"total"] floatValue]];
        self.centerLabel.text = [NSString stringWithFormat:@"%.2f", [dictionary[@"investorCollectionCapital"] floatValue]];
    } failure:^(NSError *error) {
        SGDebugLog(@"error - - %@", error);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(JCBMineModel *)model {
    _model = model;

    if (model.repaymentMoney == 0) {
        self.rightLabel.text = @"0.00";
    } else {
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f", model.totalIncome];
    }
    [self getDataFromeNetWorking];
}


@end
