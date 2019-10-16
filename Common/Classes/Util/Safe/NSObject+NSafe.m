//
//  NSObject+NSafe.m
//  niuguwang
//
//  Created by BrightLi on 2017/6/5.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NSObject+NSafe.h"

@interface _UnregSelObjectProxy : NSObject

+ (instancetype) sharedInstance;

@end

@implementation _UnregSelObjectProxy

+ (instancetype) sharedInstance{
    
    static _UnregSelObjectProxy *instance=nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[_UnregSelObjectProxy alloc] init];
    });
    return instance;
}

+ (BOOL) resolveInstanceMethod:(SEL)selector {
    
    class_addMethod([self class], selector,(IMP)emptyMethodIMP,"v@:");
    return YES;
}

void emptyMethodIMP(){
    NSLog(@"nothing");
}

@end


static const void *keypathMapKey=&keypathMapKey;
static const void *kvoSafeToggleKey=&kvoSafeToggleKey;

@implementation NSObject(NSafe)

+ (void) fixed
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSafe swizzleMethod:[self class]
                    original:@selector(addObserver:forKeyPath:options:context:)
                    swizzled:@selector(n_addObserver:forKeyPath:options:context:)];
        [NSafe swizzleMethod:[self class]
                    original:@selector(removeObserver:forKeyPath:)
                    swizzled:@selector(n_removeObserver:forKeyPath:)];
        [NSafe swizzleMethod:[self class]
                    original:@selector(methodSignatureForSelector:)
                    swizzled:@selector(n_methodSignatureForSelector:)];
        [NSafe swizzleMethod:[self class]
                    original:@selector(forwardInvocation:)
                    swizzled:@selector(n_forwardInvocation:)];
    });
}

- (void) n_swizzleMethod:(SEL) original
                swizzled:(SEL) swizzled
{
    [NSafe swizzleMethod:[self class] original:original swizzled:swizzled];
}

- (NSMapTable <id, NSHashTable<NSString *> *> *)keypathMap
{
    NSMapTable *keypathMap = objc_getAssociatedObject(self, &keypathMapKey);
    if (keypathMap) {
        return keypathMap;
    }
    keypathMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
    objc_setAssociatedObject(self, &keypathMapKey, keypathMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return keypathMap;
}

- (void) setKeypathMap:(id)map
{
    if (map) {
        objc_setAssociatedObject(self, keypathMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(BOOL) kvoSafteyToggle
{
    return  [objc_getAssociatedObject(self, &kvoSafeToggleKey) boolValue];
}

-(void) setKvoSafteyToggle:(BOOL)on
{
    objc_setAssociatedObject(self, &kvoSafeToggleKey, @(on), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) n_addObserver:(NSObject *)observer
           forKeyPath:(NSString *)keyPath
              options:(NSKeyValueObservingOptions)options
              context:(void *)context
{
    if (self.kvoSafteyToggle) {
        if (!observer || !keyPath) {
            return;
        }
        NSHashTable *table = [[self keypathMap] objectForKey:observer];
        if (!table) {
            table =  [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
            [table addObject:keyPath];
            [[self keypathMap] setObject:table forKey:observer];
            [self n_addObserver:observer forKeyPath:keyPath options:options context:context];
            return;
        }
        if ([table containsObject:keyPath]) {
            [GLog stackInfo:@"%@已加入KVO:%@",self,keyPath];
            return;
        }
        [table addObject:keyPath];
    }
    [self n_addObserver:observer forKeyPath:keyPath options:options context:context];
}

-(void) n_removeObserver:(NSObject *)observer
              forKeyPath:(NSString *)keyPath
{
    if (self.kvoSafteyToggle) {
        if(!observer || !keyPath){
            return;
        }
        NSHashTable *table = [[self keypathMap] objectForKey:observer];
        if (!table) {
            return;
        }
        if (![table containsObject:keyPath]) {
            [GLog stackInfo:@"%@已移除KVO:%@",self,keyPath];
            return;
        }
        [table removeObject:keyPath];
    }
    [self n_removeObserver:observer forKeyPath:keyPath];
}
// 是否有这个方法
- (BOOL) hasSEL:(NSString *) sel
{
    unsigned int methodCount =0;
    Method* methodList = class_copyMethodList([self class],&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(methodList);
    for (NSString *method in [methodsArray copy]) {
        if ([method isEqualToString:sel]) {
            return YES;
        }
    }
    return NO;
}
// 运行方法
- (id) runSEL:(SEL)sel withObjects:(NSArray *)objects
{
    NSMethodSignature *signature = [self methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:sel];
    NSUInteger i = 1;
    for (id object in objects) {
        id tempObject = object;
        [invocation setArgument:&tempObject atIndex:++i];
    }
    [invocation invoke];
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

- (NSMethodSignature *)n_methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature *sig;
    sig = [self n_methodSignatureForSelector:sel];
    if (sig) {
        return sig;
    }
    // UIKeyboardInputManagerMux UIKeyboardInputManagerClient
    // syncToKeyboardState:completionHandler:
    // performHitTestForTouchEvent:keyboardState:continuation:
    // generateCandidatesWithKeyboardState:candidateRange:completionHandler:
    // handleKeyboardInput:keyboardState:completionHandler:
    // handleAcceptedCandidate:keyboardState:completionHandlerWithKeyboardOutput:
    NSString *className=NSStringFromClass([self class]);
    NSString *selName=[[NSString alloc] initWithUTF8String:sel_getName(sel)];
    if([className hasPrefix:@"UIKeyboardInputManager"]){
        [GLog debug:selName];
        return nil;
    }
    sig = [[_UnregSelObjectProxy sharedInstance] n_methodSignatureForSelector:sel];
    if (sig){
        return sig;
    }
    return nil;
}

-(void) n_forwardInvocation:(NSInvocation *)anInvocation
{
    if(self==nil){
        NSLog(@"WHY");
    }
    [anInvocation invokeWithTarget:[_UnregSelObjectProxy sharedInstance]];
    [GLog stackInfo:@"警告:对象未实现该方法"];
}

@end
