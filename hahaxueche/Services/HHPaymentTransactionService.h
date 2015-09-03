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
#import "HHPaymentStatus.h"
#import "HHTransfer.h"

typedef void (^HHTransactionGenericCompletionBlock)(NSArray *objects, NSError *error);
typedef void (^HHPaymentStatusGenericCompletionBlock)(HHPaymentStatus *paymentStatus, NSError *error);

@interface HHPaymentTransactionService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchTransactionWithCompletion:(HHTransactionGenericCompletionBlock)completion;

- (void)fetchPaymentStatusWithTransactionId:(NSString *)transactionId completion:(HHPaymentStatusGenericCompletionBlock)completion;

- (void)fetchTransferWithTransactionId:(NSString *)transactionId completion:(HHTransactionGenericCompletionBlock)completion;

@end
