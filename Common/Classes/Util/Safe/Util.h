//
//  Header.h
//  Common
//
//  Created by ngw15 on 2019/10/19.
//  Copyright © 2019 lijun. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define OtherTagKeyboard 1801
#define WEAK_SELF __weak typeof(self) weakSelf=self
#define GCD_LOCK() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define UN_GCD_LOCK() dispatch_semaphore_signal(self.lock)

#import "GLog.h"
#import "NDataUtil.h"
#import "NSafe.h"

#endif /* Header_h */
