//
//  FOWebService.h
//  niuguwang
//
//  Created by jly on 17/3/24.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

//HTTP请求参数包头类型
typedef NS_ENUM(NSInteger,HttpHeadType)
{
    HttpGuestHead,  //不传userToken
    HttpBaseHead,   //带有userToken
    HttpTradeHead,  //带有userToken、tradetoken
};


extern NSString *const NetWorkStatusChanged;

@interface FOWebService : NSObject

@property (nonatomic,assign) NetworkStatus status;

+ (instancetype)sharedInstance;
+ (NSDictionary *) dictWithCache:(NSURLSessionDataTask *) task;
+ (NSURLSessionDataTask *) jsonWithPost:(NSString *)url
                                 params:(NSString *)params
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask*) jsonWithThirdPost:(NSString *)path
                                     params:(NSString *)params
                                    success:(void (^)(id data)) success
                                    failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask *) dataWithGet:(NSString *)url
                                params:(NSString *)params
                               success:(void (^)(id data)) success
                               failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask*) jsonAndResponseWithGet:(NSString *)url
                                          params:(NSString *)params
                                         success:(void (^)(id data,NSURLResponse* response)) success
                                         failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask *) jsonWithGet:(NSString *)url
                                params:(NSString *)params
                               success:(void (^)(id data)) success
                               failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask *) desWithGet:(NSString *)url
                               params:(NSString *)params
                               desKey:(NSString *)desKey
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask *) desWithPost:(NSString *)url
                                params:(NSString *)params
                                desKey:(NSString *)desKey
                               success:(void (^)(id data)) success
                               failure:(void (^)(NSError *error)) failure;

+ (void)upLoadData:(NSURL *)url
             param:(NSDictionary *)params
           success:(void (^)(id data)) success
           failure:(void (^)(NSError *error)) failure;

//+ (void) postimageWithPost:(NSString *)url
//                                images:(NSArray *)images
//                               success:(void (^)(id data)) success
//                               failure:(void (^)(NSError *error)) failure;

// URL编码
+ (NSString *) encodeURL:(NSString *) target;
// 取消网络请求
+ (void) cancelTask:(NSURLSessionTask *) target;
// 取消所有的网络请求
+ (void) cancelAll;

// 解析JSON
- (id) toJson:(NSString *)path
         data:(NSData *) data;
@end
