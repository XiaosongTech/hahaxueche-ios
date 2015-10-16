//
//  HHPaymentTransactionService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/27/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHPaymentTransactionService.h"
#import "HHUserAuthenticator.h"

@implementation HHPaymentTransactionService


+ (HHPaymentTransactionService *)sharedInstance {
    static HHPaymentTransactionService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHPaymentTransactionService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchTransactionWithStudentId:(NSString *)studentId completion:(HHTransactionGenericCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHTransaction parseClassName]];
    [query whereKey:@"studentId" equalTo:studentId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];
}

- (void)fetchPaymentStatusWithTransactionId:(NSString *)transactionId completion:(HHPaymentStatusGenericCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHPaymentStatus parseClassName]];
    [query whereKey:@"transactionId" equalTo:transactionId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion((HHPaymentStatus *)[objects firstObject], error);
        }
    }];
}

- (void)fetchTransferWithTransactionId:(NSString *)transactionId completion:(HHTransactionGenericCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHTransfer parseClassName]];
    [query whereKey:@"transactionId" equalTo:transactionId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];
}


@end
