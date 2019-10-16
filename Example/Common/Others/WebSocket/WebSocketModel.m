//
//  WebSocketModel.m
//  BitInfi
//
//  Created by nwg15
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "WebSocketModel.h"
#import "DCService.h"

static NSString * const KMarketWssUrlKey = @"KMarketWssUrlKey";


@interface WebSocketModel ()

@end
@implementation WebSocketModel
// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static WebSocketModel * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[[self class] alloc] init];
    });
    return sharedInstance;
}
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

// 预加载
- (void) preload{
    
//    [self requestWssUrl];
}
//持久化当前的
-(void)storeCurrentUserWssUrl
{
    [NLocalUtil setString:_marketWssUrl forKey:KMarketWssUrlKey];
}

-(NSString *)marketWssUrl
{
    if ([NDataUtil stringIsBlank:_marketWssUrl]) {
        return [NSString stringWithFormat:@"wss://push.%@",FTConfig.domainname];
    }
    return _marketWssUrl;
}

-(void)requestWssUrl
{
    WEAK_SELF;
    [DCService wssAddressUrl:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"errNum" isEqual:@"99999"]) {
            NSDictionary *dict = [[NDataUtil arrayWith:data[@"retData"]] firstObject];
            weakSelf.marketWssUrl = [NSString stringWithFormat:@"wss://%@:%@",[NDataUtil stringWith:dict[@"address"] valid:@""],[NDataUtil stringWith:dict[@"port"] valid:@""]];
            [[WebSocketModel sharedInstance] storeCurrentUserWssUrl];
        }else{
            [weakSelf againRequest];
        }
    } failure:^(NSError *error) {
//        [weakSelf againRequest];
    }];
}

- (void)againRequest{
    WEAK_SELF;
    [NTimeUtil run:^{
        [weakSelf requestWssUrl];
    } delay:5];
}

@end
