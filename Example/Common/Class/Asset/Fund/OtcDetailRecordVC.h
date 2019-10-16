//
//  OtcDetailRecordVC.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OtcDetailRecordVC : NBaseVC

+ (void)jumpTo:(NSString *)logid txtId:(NSString *)txtId isDeposit:(BOOL)isDeposit;

@end

NS_ASSUME_NONNULL_END
