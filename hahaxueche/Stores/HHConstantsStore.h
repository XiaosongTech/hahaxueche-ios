//
//  HHConstantsStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHConstants.h"

typedef void (^HHConstantsCompletion)(HHConstants *constants);

@interface HHConstantsStore : NSObject

+ (instancetype)sharedInstance;
- (void)getConstantsWithCompletion:(HHConstantsCompletion)completion;


@end