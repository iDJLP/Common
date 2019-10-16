//
//  ThreadSafeArray.h
//  线程安全数组
//
//  Created by 李明 on 16/9/15.
//  Copyright (c) 2016 taojinzhe.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

/**
 A simple implementation of thread safe mutable array.
 
 @discussion Generally, access performance is lower than NSMutableArray,
 but higher than using @synchronized, NSLock, or pthread_mutex_t.
 
 @discussion It's also compatible with the custom methods in `NSArray(YYAdd)`
 and `NSMutableArray(YYAdd)`
 
 @warning Fast enumerate(for..in) and enumerator is not thread safe,
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the array inside the block/callback.
 */
@interface ThreadSafeArray : NSMutableArray
- (NSMutableArray*)retMutableArray;

- (NSUInteger)count_unLock;

- (id)objectAtIndex_unLock:(NSUInteger)index;
@end
