//
//  NUDID.m
//  ngw-os
//
//  Created by 李明 on 16/3/27.
//  Copyright © 2016年 李明. All rights reserved.
//

#import "NUDID.h"
#import <AdSupport/AdSupport.h>
#import <Bugly/Bugly.h>
#import "NKeyChain.h"

@implementation NUDID

// 获得设备唯一ID
+(NSString *) deviceId
{
    return [Bugly buglyDeviceId];
}
// 获得IDFA
+ (NSString *) idfa
{
    NSString *checkIdfa=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *idfa=[NKeyChain stringForKey:@"idfa"];
    if(idfa.length<1){
        if(checkIdfa.length>0){
            idfa=checkIdfa;
            [NKeyChain setString:idfa forKey:@"idfa"];
        }else{
            idfa=@"00000000-0000-0000-0000-000000000000";
        }
    }
    return idfa;
}

@end
