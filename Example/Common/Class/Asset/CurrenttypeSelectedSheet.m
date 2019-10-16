//
//  CurrenttypeSelectedSheet.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CurrenttypeSelectedSheet.h"
#import "SelectedSheet.h"

@interface CurrenttypeSelectedSheet ()

@property (nonatomic,strong)NSArray *dataList;
@property (nonatomic,assign)BOOL isLoad;
@end

@implementation CurrenttypeSelectedSheet

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CurrenttypeSelectedSheet * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[CurrenttypeSelectedSheet alloc] init];
    });
    return sharedInstance;
}

+ (void)loadData:(dispatch_block_t)success failure:(dispatch_block_t)failure{
    [HUDUtil showProgress:@""];
    [DCService getcurrencylist:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil hide];
            [CurrenttypeSelectedSheet sharedInstance].isLoad = YES;
            [CurrenttypeSelectedSheet sharedInstance].dataList = [NDataUtil arrayWith:data[@"data"]];
            success();
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

+ (NSArray *)dataListAddSelected:(NSString *)selected{
    NSArray *list = [CurrenttypeSelectedSheet sharedInstance].dataList;
    NSMutableArray *tem = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        NSMutableDictionary *dict = dic.mutableCopy;
        if ([NDataUtil boolWithDic:dic key:@"currency" isEqual:selected]) {
            [dict setObject:@"1" forKey:@"isSelected"];
        }
        [tem addObject:dict];
    }
    return tem;
}

+ (void)loadVarityLogo:(NSString *)selected success:(void (^)(NSString *imgName))hander{
    if ([CurrenttypeSelectedSheet sharedInstance].isLoad) {
        NSArray *list = [CurrenttypeSelectedSheet sharedInstance].dataList;
        NSString *imgName = @"";
        for (NSDictionary *dic in list) {
            if ([NDataUtil boolWithDic:dic key:@"currency" isEqual:selected]) {
                imgName = [NDataUtil stringWith:dic[@"icon"]];
            }
        }
        hander(imgName);
    }else{
        
        [self loadData:^{
            
            [self loadVarityLogo:selected success:hander];
        } failure:^{
            
        }];
    }
}

+ (void)showAlert:(NSString *)title
         selected:(NSString *)selected
       sureHander:(void(^)(NSDictionary *))sureHander{
    
    if ([CurrenttypeSelectedSheet sharedInstance].isLoad) {
        NSArray *dataList = [self dataListAddSelected:selected];
        [SelectedSheet showAlert:title dataList:dataList sureHander:sureHander];
    }else{

        [self loadData:^{
            
            [self showAlert:title selected:selected sureHander:sureHander];
        } failure:^{
            
        }];
    }
}

@end



