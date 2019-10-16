//
//  DomainUtil.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/27.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DomainUtil.h"

@interface DomainUtil ()

@property (nonatomic,strong)NSArray *demainList;
@property (nonatomic,assign)NSInteger idx;

@end

@implementation DomainUtil

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static DomainUtil * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[DomainUtil alloc] init];
    });
    return sharedInstance;
}

+ (void)loadList{
    NSString *domain = [NLocalUtil stringForKey:@"app_domain"];
    if (domain.length>0) {
        [FTConfig sharedInstance].domainname = domain;
        [NLocalUtil setObject:domain forKey:@"app_domain"];
    }
    [DCService getDomain:^(id data) {
        [DomainUtil sharedInstance].demainList = data;
        NSInteger idx = 0;
        for (NSInteger i=0;i<[DomainUtil sharedInstance].demainList.count;i++) {
            NSDictionary *dict = [NDataUtil dataWithArray:[DomainUtil sharedInstance].demainList index:i];
            NSString *domain = [NDataUtil stringWith:dict[@"domain"]];
            if ([domain isEqualToString:[FTConfig sharedInstance].domainname]) {
                idx = i;
            }
        }
        [DomainUtil sharedInstance].idx = idx;
        if ([DomainUtil sharedInstance].idx == NSNotFound) {
            [DomainUtil sharedInstance].idx = 0;
            NSDictionary *dic = [NDataUtil dictWithArray:[DomainUtil sharedInstance].demainList index:[DomainUtil sharedInstance].idx];
            [FTConfig sharedInstance].domainname = [NDataUtil stringWith:dic[@"domain"]];
            [NLocalUtil setObject:[FTConfig sharedInstance].domainname forKey:@"app_domain"];
        }
        [self startTimer];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)startTimer{
    [NTimeUtil startTimer:@"DomainUtil" interval:15 repeats:YES action:^{
        [self checkDomain];
    }];
}

+ (void)checkDomain{
    [DCService checkDomain:^(id data) {
        
    } failure:^(NSError *error) {
        if (error==nil) {
            [self changedDomain];
            [self checkDomain];
        }
    }];
}

+ (void)changedDomain{
    NSLog(@"lijun:%ld",[DomainUtil sharedInstance].idx);
    [DomainUtil sharedInstance].idx ++;
    if ([DomainUtil sharedInstance].idx>=[DomainUtil sharedInstance].demainList.count) {
        [DomainUtil sharedInstance].idx=0;
    }
    NSDictionary *dic = [NDataUtil dictWithArray:[DomainUtil sharedInstance].demainList index:[DomainUtil sharedInstance].idx];
    [FTConfig sharedInstance].domainname = [NDataUtil stringWith:dic[@"domain"]];
    [NLocalUtil setObject:[FTConfig sharedInstance].domainname forKey:@"app_domain"];
}
@end
