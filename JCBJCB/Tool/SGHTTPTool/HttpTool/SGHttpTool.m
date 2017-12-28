//
//  SGHttpTool.m
//  SGHttpTool
//
//  Created by Sorgle on 15/7/13.
//  Copyright © 2015年 Sorgle. All rights reserved.
//
//  获取不同的数据格式: manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];

#import "SGHttpTool.h"
#import "AFNetworking.h"

@implementation SGHttpTool

static CGFloat const SG_timeout = 10.0;

/** GET请求(all数据格式) */
+ (void)getAll:(NSString *)url params:(NSDictionary *)params success:(void (^)(id dictionary))success failure:(void (^)(NSError *error))failure {
    // 创建AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求头
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    // 获取json/plain/html/javascript类型数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", @"text/javascript", nil];
    
    // 配置 Https SSL 证书
    //[manager setSecurityPolicy:[self customSecurityPolicy]];
    
    // 设置请求超时的时间
    manager.requestSerializer.timeoutInterval = SG_timeout;
    
    // 请求数据
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
    //               POST               //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - //


/** POST请求(all数据格式) */
+ (void)postAll:(NSString *)url params:(NSDictionary *)params success:(void (^)(id dictionary))success failure:(void (^)(NSError *error))failure {

    // 创建AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 配置 Https SSL 证书
    //[manager setSecurityPolicy:securityPolicy];
    
    // 获取json/plain/html/javascript类型数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", @"text/javascript", nil];
    
    // 设置请求超时的时间
    manager.requestSerializer.timeoutInterval = SG_timeout;
    
    // 请求数据
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}


/** AFN POST上传JSON格式 */
+ (void)postJson:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置json数据类型
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 请求数据
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** GET请求HTML界面 */
+ (void)getHTML:(NSString *)url params:(NSDictionary *)params success:(void (^)(id dictionary))success failure:(void (^)(NSError *error))failure {
    // 创建AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求超时的时间
    manager.requestSerializer.timeoutInterval = SG_timeout;
    // 请求数据
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


/** 配置 Https SSL 证书 */
+ (AFSecurityPolicy*)customSecurityPolicy {
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"]; // 证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES; 允许自检证书
    securityPolicy.allowInvalidCertificates = YES;
    
    // validatesDomainName 是否需要验证域名，默认为YES；
    // 假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开
    // 置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的
    // 如置为NO，建议自己添加对应域名的校验逻辑
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData]; //@[certData];
    
    return securityPolicy;
}


@end


