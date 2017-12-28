//
//  SGHttpTool.h
//  SGHttpTool
//
//  Created by Sorgle on 15/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGHttpTool : NSObject

/** GET请求(all数据格式) */
+ (void)getAll:(NSString *)url params:(NSDictionary *)params success:(void (^)(id dictionary))success failure:(void (^)(NSError *error))failure;


/** POST请求(all数据格式) */
+ (void)postAll:(NSString *)url params:(NSDictionary *)params success:(void (^)(id dictionary))success failure:(void (^)(NSError *error))failure;


/** AFN POST上传JSON格式 */
+ (void)postJson:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/** GET请求HTML界面 */
+ (void)getHTML:(NSString *)url params:(NSDictionary *)params success:(void (^)(id dictionary))success failure:(void (^)(NSError *error))failure;

@end


// text/html的意思是将文件的content-type设置为text/html的形式，浏览器在获取到这种文件时会自动调用html的解析器对文件进行相应的处理。

// text/plain的意思是将文件设置为纯文本的形式，浏览器在获取到这种文件时并不会对其进行处理。

