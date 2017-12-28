//
//  JCBBaoFuPayModel.h
//  JCBJCB
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCBBaoFuPayModel : JCBModel
/** back_url */
@property (nonatomic, copy) NSString *back_url;
/** 加密参数 */
@property (nonatomic, copy) NSString *data_content;
/** 加密数据类型 */
@property (nonatomic, copy) NSString *data_type;
/** 字符集 */
@property (nonatomic, copy) NSString *input_charset;
/** 网关页面显示语言 种类 */
@property (nonatomic, copy) NSString *language;
/** 商户号 */
@property (nonatomic, copy) NSString *member_id;
/** 终端号 */
@property (nonatomic, copy) NSString *terminal_id;
/** 交易子类 */
@property (nonatomic, copy) NSString *txn_sub_type;
/** 交易类型 */
@property (nonatomic, copy) NSString *txn_type;
/** 版本号 */
@property (nonatomic, copy) NSString *version;


@end
