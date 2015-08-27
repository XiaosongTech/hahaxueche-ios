//
//  HHPaymentTransactionService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/27/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHTransaction.h"

typedef void (^HHTransactionGenericCompletionBlock)(NSArray *objects, NSError *error);

@interface HHPaymentTransactionService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchTransactionWithCompletion:(HHTransactionGenericCompletionBlock)completion;

@end
