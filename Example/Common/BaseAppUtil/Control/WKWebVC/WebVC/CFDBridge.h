//
//  CFDBridge.h
//  LiveTrade
//
//  Created by ngw15 on 2018/11/29.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import "WebViewJavascriptBridge.h"


NS_ASSUME_NONNULL_BEGIN

@interface CFDBridge : NSObject

// GCD单例
+ (instancetype)sharedInstance;
- (void)setup:(WebViewJavascriptBridge *)bridge;

@end

NS_ASSUME_NONNULL_END
