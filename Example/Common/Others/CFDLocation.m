//
//  QZHLocation.m
//  niuguwang
//
//  Created by ngw15 on 2018/3/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface CFDLocation ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation CFDLocation

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CFDLocation * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[CFDLocation alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _ipInfo = @"";
        _locationInfo = @"";
        _ipUrl = @"http://ip.taobao.com/service/getIpInfo.php?ip=myip";
    }
    return self;
}

- (void)startLocation{
    if (!_locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = 1000.0f;
        if ([[[UIDevice currentDevice] systemVersion]doubleValue] >8.0){
            [self.locationManager requestWhenInUseAuthorization];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    [self.locationManager startUpdatingLocation];
}

/*定位成功后则执行此代理方法*/
#pragma mark 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_locationManager stopUpdatingLocation];
    /*旧值*/
    CLLocation * currentLocation = [locations lastObject];
    _locationInfo = [NSString stringWithFormat:@"%f*%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
}

- (void)setIpUrl:(NSString *)ipUrl{
    _ipUrl = ipUrl;
    if (_ipInfo.length<=0) {
        [self getIpInfo];
    }
}

- (void)didBecomeActive{
    [self getIpInfo];
    [self startLocation];
}

- (void)getIpInfo{
    WEAK_SELF;
    [DCService getIPInfo:_ipUrl success:^(id data) {
        [weakSelf ipInfoByData:data];
    } failure:^(NSError *error) {

    }];
}

- (void )ipInfoByData:(id)data{
    WEAK_SELF;
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        NSArray *values = [data allObjects];
        [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [weakSelf ipInfoByData:obj];
        }];
        
    }else if ([data isKindOfClass:[NSArray class]]){
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [weakSelf ipInfoByData:obj];
        }];
    }else if ([data isKindOfClass:[NSString class]]){
        //正则
        NSString *regular = @"^((25[0-5]|2[0-4]\\d|[1]{1}\\d{1}\\d{1}|[1-9]{1}\\d{1}|\\d{1})($|(?!\\.$)\\.)){4}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
        if ([pred1 evaluateWithObject:data]) {
            _ipInfo = data;
        }
    }
}

@end

