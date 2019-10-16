//
//  FundDetailVC.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChainDetailRecordVC : NBaseVC

+ (void)jumpTo:(NSString *)logid
         txtId:(NSString *)txtId
          date:(NSString *)date
   currenttype:(NSString *)currenttype
     isDeposit:(BOOL)isDeposit;

@end

NS_ASSUME_NONNULL_END
