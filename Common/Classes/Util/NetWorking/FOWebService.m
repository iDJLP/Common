//
//  HOWebService.m
//  niuguwang
//
//  Created by djl on 16/10/28.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "FOWebService.h"


//#import "AFNetworking.h"

NSString *const NetWorkStatusChanged = @"NetWorkStatusChanged";

@interface FOWebService ()
@property (nonatomic,strong) NSMutableDictionary *tasks;
@property (nonatomic,strong) Reachability *hostReach;
@property (nonatomic,strong) dispatch_semaphore_t lock;
@end

@implementation FOWebService
#pragma mark - 静态方法

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FOWebService * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[FOWebService alloc] init];
    });
    return sharedInstance;
}

+ (NSURLSessionDataTask*) jsonWithPost:(NSString *)url
                                params:(NSString *)params
                               success:(void (^)(id data)) success
                               failure:(void (^)(NSError *error)) failure
{
    return [[self sharedInstance] jsonWithPost:(NSString *)url
                                        params:(NSString *)params
                                       success:(void (^)(id data)) success
                                       failure:(void (^)(NSError *error)) failure];
}
+ (NSURLSessionDataTask*) dataWithGet:(NSString *)url
                               params:(NSString *)params
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure
{
    return [[self sharedInstance] dataWithGet:(NSString *)url
                                       params:(NSString *)params
                                      success:(void (^)(id data)) success
                                      failure:(void (^)(NSError *error)) failure];
}

+ (NSURLSessionDataTask*) jsonAndResponseWithGet:(NSString *)url
                                          params:(NSString *)params
                                         success:(void (^)(id data,NSURLResponse* response)) success
                                         failure:(void (^)(NSError *error)) failure
{
    return [[self sharedInstance] jsonAndResponseWithGet:(NSString *)url
                                                  params:(NSString *)params
                                                 success:(void (^)(id data,NSURLResponse* response)) success
                                                 failure:(void (^)(NSError *error)) failure];
}

+ (NSURLSessionDataTask*) jsonWithGet:(NSString *)url
                               params:(NSString *)params
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure
{
    return [[self sharedInstance] jsonWithGet:(NSString *)url
                                       params:(NSString *)params
                                      success:(void (^)(id data)) success
                                      failure:(void (^)(NSError *error)) failure];
}
+ (NSURLSessionDataTask*) desWithGet:(NSString *)url
                              params:(NSString *)params
                              desKey:(NSString *)desKey
                             success:(void (^)(id data)) success
                             failure:(void (^)(NSError *error)) failure
{
    return [[self sharedInstance] desWithGet:(NSString *)url
                                      params:(NSString *)params
                                      desKey:(NSString *)desKey
                                     success:(void (^)(id data)) success
                                     failure:(void (^)(NSError *error)) failure];
}
+ (NSURLSessionDataTask*) desWithPost:(NSString *)url
                               params:(NSString *)params
                               desKey:(NSString *)desKey
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure
{
    return [[self sharedInstance] desWithPost:(NSString *)url
                                       params:(NSString *)params
                                       desKey:(NSString *)desKey
                                      success:(void (^)(id data)) success
                                      failure:(void (^)(NSError *error)) failure];
}


//+ (void) postimageWithPost:(NSString *)url
//                    images:(NSArray *)images
//                   success:(void (^)(id))success
//                   failure:(void (^)(NSError *))failure
//{
//
//
//    [[self sharedInstance]postimageWithPost:url
//                                     images:images
//                                    success:success
//                                    failure:failure];
//}

+ (NSString *) encodeURL:(NSString *)target
{
    return [target stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?&=;+!@#$()',* "].invertedSet];
}
+ (void) cancelTask:(NSURLSessionTask *)task
{
    [[self sharedInstance] cancelTask:task];
}

+ (void) cancelAll{
    [[self sharedInstance] cancelAll];
}

#pragma mark - 私有方法

- (instancetype) init{
    if ((self = [super init]))
    {
        _lock=dispatch_semaphore_create(1);
        _tasks=[[NSMutableDictionary alloc]init];
        _status=-1;
        [self initReach];
    }
    return self;
}
// 初始化网络检测
- (void) initReach
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    _hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [_hostReach startNotifier];
    [self updateInterfaceWithReachability:_hostReach];
}
// 网络检测通知
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    [self updateInterfaceWithReachability:curReach];
}
// 更新网络状态
- (void) updateInterfaceWithReachability:(Reachability *)reachability
{
    if(_status==[reachability currentReachabilityStatus])
    {
        return;
    }
    _status = [reachability currentReachabilityStatus];
    if(_status==NotReachable){
        BLYLogInfo(@"网络断开!");
        return;
    }
    if(_status==ReachableViaWiFi){
        BLYLogInfo(@"已联网WIFI");
        return;
    }
    if(_status==ReachableViaWWAN){
        BLYLogInfo(@"已联网4G");
    }
}
// GET请求 https/gzip 返回数据
- (NSURLSessionDataTask*) dataWithGet:(NSString *)path
                               params:(NSString *)params
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure
{
    // 参数
    if(params){
        path=[path stringByAppendingFormat:@"?%@",[params stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    }
//    NSURLSessionDataTask *task=[self taskWith:path];
//    if(task!=nil){
//        return task;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });    // 创建请求头
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:[NSURL URLWithString:path]];
    // 请求方式
    [request setHTTPMethod:@"GET"];
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    // 使用压缩数据返回
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSession *session=[NSURLSession sharedSession];
    __weak typeof(self) weakSelf=self;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      BLYLogWarn(@"网络错误:%@",error);
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      [weakSelf removeTask:path];
                      return;
                  }
                  NSLog(@"成功返回:%@",path);
                  if(success!=nil){
                      dispatch_async(dispatch_get_main_queue(),^{
                          success(data);
                      });
                  }
                  [weakSelf removeTask:path];
              });
          }];
    [task resume];
    [self addTask:task key:path];
    return task;
}
// GET请求 https/gzip 返回JSON数据
- (NSURLSessionDataTask*) jsonWithGet:(NSString *)path
                               params:(NSString *)params
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure;
{
    if(params.length>=1){
        path=[NSString stringWithFormat:@"%@?%@",[path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],[params stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];//编码－可能含有中文字符
    }
//    NSURLSessionDataTask *task=[self taskWith:path];
//    if(task!=nil){
//        return task;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    NSURL *url=[NSURL URLWithString:path];
    // 创建请求头
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:url];
    // 请求方式
    [request setHTTPMethod:@"GET"];
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    // 使用压缩数据返回
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSession *session=[NSURLSession sharedSession];
    __weak typeof(self) weakSelf=self;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      BLYLogWarn(@"[%@]网络错误:%@",path,error);
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      [weakSelf removeTask:path];
                      return;
                  }
                  if(data!=nil){
                      if (data.length==0) { NSLog(@"成功返回:%@",path);
                          if(success!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  success(nil);
                              });
                          }
                          return;
                      }
                      id obj=[weakSelf toJson:path data:data];
                      if(obj==nil ||[obj isKindOfClass:[NSError class]]){
                          if(failure!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  failure(obj);
                              });
                          }
                      }else{
                          NSLog(@"成功返回:%@",path);
                          if(success!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  success(obj);
                              });
                          }
                      }
                  }else{
                      BLYLogWarn(@"返回数据为空:%@",path);
                  }
                  [weakSelf removeTask:path];
              });
          }];
    [task resume];
    [self addTask:task key:path];
    return task;
}

// GET请求 https/gzip 返回JSON数据
- (NSURLSessionDataTask*) jsonAndResponseWithGet:(NSString *)path
                                          params:(NSString *)params
                                         success:(void (^)(id data,NSURLResponse* response)) success
                                         failure:(void (^)(NSError *error)) failure;
{
    if(path.length<1 || params.length<1){
        return nil;
    }
    path=[NSString stringWithFormat:@"%@?%@",[path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],[params stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];//编码－可能含有中文字符
//    NSURLSessionDataTask *task=[self taskWith:path];
//    if(task!=nil){
//        return task;
//    }
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url=[NSURL URLWithString:path];
    // 创建请求头
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:url];
    // 请求方式
    [request setHTTPMethod:@"GET"];
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    // 使用压缩数据返回
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSession *session=[NSURLSession sharedSession];
    __weak typeof(self) weakSelf=self;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  //                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      NSLog(@"[%@]网络错误:%@",path,error);
                      BLYLogWarn(@"[%@]网络错误:%@",path,error);
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      [weakSelf removeTask:path];
                      return;
                  }
                  if(data!=nil){
                      id obj=[weakSelf toJson:path data:data];
                      if(obj==nil ||[obj isKindOfClass:[NSError class]]){
                          if(failure!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  failure(obj);
                              });
                          }
                      }else{
                          NSLog(@"成功返回:%@",path);
                          if(success!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  success(obj,response);
                              });
                          }
                      }
                  }else{
                      BLYLogWarn(@"返回数据为空:%@",path);
                  }
                  [weakSelf removeTask:path];
              });
          }];
    [task resume];
    [self addTask:task key:path];
    return task;
}

// POST请求 https/gzip返回JSON数据
- (NSURLSessionDataTask*) jsonWithPost:(NSString *)path
                                params:(NSString *)params
                               success:(void (^)(id data)) success
                               failure:(void (^)(NSError *error)) failure
{
    NSString *key=[NSString stringWithFormat:@"%@?%@",[path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],[params stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
//    NSURLSessionDataTask *task=[self taskWith:key];
//    if(task!=nil){
//        return task;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    // 创建请求头
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    // 请求方式
    [request setHTTPMethod:@"POST"];
    // 如果有参数
    if(params.length>0){
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    // 使用压缩数据返回
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSession *session=[NSURLSession sharedSession];
    __weak typeof(self) weakSelf=self;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      BLYLogWarn(@"[%@]网络错误:%@",path,error);
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      [weakSelf removeTask:key];
                      return;
                  }
                  id obj=[weakSelf toJson:path data:data];
                  
                  if(obj==nil || [obj isKindOfClass:[NSError class]]){
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(obj);
                          });
                      }
                  }else{
                      NSLog(@"成功返回:%@",path);
                      if(success!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              success(obj);
                          });
                      }
                  }
                  [weakSelf removeTask:key];
              });
          }];
    [task resume];
    [self addTask:task key:key];
    return task;
}
// GET请求 https/gzip返回JSON加密数据
- (NSURLSessionDataTask*) desWithGet:(NSString *)path
                              params:(NSString *)params
                              desKey:(NSString *)desKey
                             success:(void (^)(id data)) success
                             failure:(void (^)(NSError *error)) failure
{
    // 参数
    if(params.length<1){
        return nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    path=[NSString stringWithFormat:@"%@?%@",[path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],[params stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
//    NSURLSessionDataTask *task=[self taskWith:path];
//    if(task!=nil){
//        return task;
//    }
    // 创建请求头
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:[NSURL URLWithString:path]];
    // 请求方式
    [request setHTTPMethod:@"GET"];
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    NSURLSession *session=[NSURLSession sharedSession];
    __weak typeof(self) weakSelf=self;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      BLYLogWarn(@"网络错误:[%@]:%@",path,error);
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      [weakSelf removeTask:path];
                      return;
                  }
                  //异步解析JSON
                  NSString *result=[[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
                  result= [NDataUtil decodeWithDES:result
                                               key:desKey];
                  NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                  id obj=[weakSelf toJson:path data:jsonData];
                  if(obj==nil ||[obj isKindOfClass:[NSError class]]){
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(obj);
                          });
                      }
                  }else{
                      NSLog(@"成功返回:%@",path);
                      if(success!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              success(obj);
                          });
                      }
                  }
                  [weakSelf removeTask:path];
              });
          }];
    [task resume];
    [self addTask:task key:path];
    return task;
}
// POST请求 https/gzip 返回JSON加密数据
- (NSURLSessionDataTask*) desWithPost:(NSString *)path
                               params:(NSString *)params
                               desKey:(NSString *)desKey
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure
{
    NSString *key=[NSString stringWithFormat:@"%@?%@",[path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],[params stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
//    NSURLSessionDataTask *task=[self taskWith:key];
//    if(task!=nil){
//        return task;
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    // 创建请求头
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    // 请求方式
    [request setHTTPMethod:@"POST"];
    // 如果有参数
    if(params.length>0){
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    // 使用压缩数据返回
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
#if defined(SDK_myqz)
    [request setValue:@"38" forHTTPHeaderField:@"appid"];
    [request setValue:@"ec1da244871a40d2a47f95e7951ef918" forHTTPHeaderField:@"appkey"];
#else
#endif
    
    NSURLSession *session=[NSURLSession sharedSession];
    __weak typeof(self) weakSelf=self;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      BLYLogWarn(@"网络错误:[%@]:%@",path,error);
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      [weakSelf removeTask:key];
                      return;
                  }
                  NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  
#if defined (SDK_myqz)
                  result= [NDataUtil decodeWithDES_584ff1dd:result
                                                        key:desKey];
#else
                  result= [NDataUtil decodeWithDES_9bf1c9b0:result
                                                        key:desKey];
#endif
                  NSData *jsonData= [result dataUsingEncoding:NSUTF8StringEncoding];
                  id obj=[weakSelf toJson:path data:jsonData];
                  if(obj==nil ||[obj isKindOfClass:[NSError class]]){
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(obj);
                          });
                      }
                  }else{
                      NSLog(@"成功返回:%@",path);
                      if(success!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              success(obj);
                          });
                      }
                  }
                  [weakSelf removeTask:key];
              });
          }];
    [task resume];
    [self addTask:task key:key];
    return task;
}


// 取消网络请求
- (void) cancelTask:(NSURLSessionTask *) target
{
    if(target==nil){
        return;
    }
    [target cancel];
    BLYLogInfo(@"取消网络请求任务:%@",[target description]);
    GCD_LOCK();
    NSArray *keys = [_tasks allKeys];
    __weak typeof(self) weakSelf=self;
    [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionTask *task=weakSelf.tasks[obj];
        if(target==task){
            [weakSelf.tasks removeObjectForKey:obj];
            *stop=YES;
        }
    }];
    UN_GCD_LOCK();
}
// 解析JSON
- (id) toJson:(NSString *)path
         data:(NSData *) data
{
    if(data==nil || data.length<1){
        return nil;
    }
    NSError *error=nil;
    id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error==nil){
        return obj;
    }else{
        NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([json hasPrefix:@"<!DOCTYPE"]){
            BLYLogWarn(@"[%@]解析Json错误,返回的是HTML:%@",path,json);
            NSLog(@"[%@]解析Json错误,返回的是HTML:%@",path,json);
            return nil;
        }
        json = [json stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSData *jsonData=[json dataUsingEncoding:NSUTF8StringEncoding];
        error=nil;
        obj=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if(error==nil){
            BLYLogWarn(@"[path]移除非法字符解析成功:%@",path,error);
            return obj;
        }
        NSLog(@"[%@]解析Json错误",path);
        BLYLogWarn(@"[%@]解析Json错误",path);
        return error;
    }
}
// 取消所有的网络请求
- (void) cancelAll
{
    BLYLogInfo(@"取消所有网络请求");
    GCD_LOCK();
    NSArray *keys = [_tasks allKeys];
    __weak typeof(self) weakSelf=self;
    [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task=weakSelf.tasks[obj];
        [task cancel];
    }];
    [_tasks removeAllObjects];
    UN_GCD_LOCK();
}

#pragma mark - GCD线程锁访问

- (NSURLSessionDataTask *) taskWith:(NSString *)path
{
    NSURLSessionDataTask *task=nil;
    GCD_LOCK();
    task=[_tasks objectForKey:path];
    UN_GCD_LOCK();
    return task;
}

- (void) addTask:(NSURLSessionDataTask *) task
             key:(NSString *)key
{
    GCD_LOCK();
    [_tasks setObject:task forKey:key];
    UN_GCD_LOCK();
}
- (void) removeTask:(NSString *)key
{
    GCD_LOCK();
    [_tasks removeObjectForKey:key];
    UN_GCD_LOCK();
}

+ (NSDictionary *) dictWithCache:(NSURLSessionDataTask *) task
{
    return [[self sharedInstance] dictWithCache:task];
}

// 读取JSON
- (NSDictionary *) dictWithCache:(NSURLSessionDataTask *) task
{
    if(!task){
        return nil;
    }
    NSURLRequest *request=task.originalRequest;
    if(!request){
        return nil;
    }
    NSCachedURLResponse *cache=[[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    id result=[self toJson:request.URL.absoluteString data:cache.data];
    if(result && ![result isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    return result;
}

@end
