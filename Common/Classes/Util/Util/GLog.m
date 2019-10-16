//
//  NDebug.m
//  Test
//
//  Created by BrightLi on 2017/6/13.
//  Copyright © 2017年 BrightLi. All rights reserved.
//

#import "GLog.h"


@implementation GLog

// GCD单例
+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static GLog * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[GLog alloc] init];
    });
    return sharedInstance;
}
// 发生异常时的堆栈日志
+ (void) stackLog:(NSException *)exception
{
    [[self sharedInstance] stackLog:exception];
}

// 堆栈日志输出
+ (void) stackInfo:(NSString *) format, ... NS_FORMAT_FUNCTION(1,2)
{
    if(!format){
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *info= [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [[self sharedInstance] stackInfo:info];
}
// 输入到日志
+ (void) output:(NSString *)format,... NS_FORMAT_FUNCTION(1,2)
{
    if(!format){
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *info= [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [[self sharedInstance] output:info];
}

+ (void) error:(NSString *)format,... NS_FORMAT_FUNCTION(1,2)
{
    if(!format){
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *info= [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [[self sharedInstance] output:info];
#if DEBUG || DE
    NSCAssert(NO,info);
#endif
}
// 调试
+ (void) debug:(NSString *) info
{
    NSLog(@"%@",info);
}
//MARK: - 私有方法
// 初始化
- (instancetype) init
{
    if (self = [super init])
    {
        self.delegate=self;
    }
    return self;
}

- (void) output:(NSString *) info
{
#if DEBUG || DE
    NSLog(@"%@",info);
#else
    if(_delegate && [_delegate respondsToSelector:@selector(log:)]){
        [_delegate log:info];
    }
#endif
}

- (void) log:(NSString *) info
{
    NSLog(@"%@",info);
}

- (void) stackLog:(NSException *) exception
{
    //堆栈数据
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [GLog infoWithStack:callStackSymbols];
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    NSString *errorName = exception.name;
    NSString *errorReason = exception.reason;
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"n_" withString:@""];
    NSString *errorPlace=[NSString stringWithFormat:@"%@",mainCallStackSymbolMsg];
    NSString *info=[NSString stringWithFormat:@"-闪退报告-:\n闪退名称:%@\n闪退原因:%@\n闪退位置:%@", errorName, errorReason, errorPlace];
    if(_delegate && [_delegate respondsToSelector:@selector(log:)]){
        [_delegate log:info];
    }
}

// 调试
- (void) stackInfo:(NSString *) reason
{
    //堆栈数据
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [GLog infoWithStack:callStackSymbols];
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    NSString *errorName = @"调试";
    NSString *errorReason = reason;
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"n_" withString:@""];
    NSString *errorPlace=[NSString stringWithFormat:@"%@",mainCallStackSymbolMsg];
    NSString *info=[NSString stringWithFormat:@"-闪退报告-:\n闪退名称:%@\n闪退原因:%@\n闪退位置:%@", errorName, errorReason, errorPlace];
    if(_delegate && [_delegate respondsToSelector:@selector(log:)]){
        [_delegate log:info];
    }
}

// 获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
+ (NSString *) infoWithStack:(NSArray<NSString *> *)callStackSymbols
{
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}

@end
