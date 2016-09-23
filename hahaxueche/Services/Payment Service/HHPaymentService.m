//
//  HHPaymentService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentService.h"
#import "HHAPIClient.h"
#import "APIPaths.h"
#import "HHToastManager.h"
#import "HHStudentStore.h"
#import "HHLoadingViewUtility.h"

@implementation HHPaymentService

+ (instancetype)sharedInstance {
    static HHPaymentService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHPaymentService alloc] init];
    });
    
    return sharedInstance;
}

- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId paymentMethod:(StudentPaymentMethod)paymentMethod productType:(CoachProductType)productType inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion {
    
    // 0-Alipay; 4-银行卡; 1-分期乐
    NSNumber *paymentMethodNumber = @(0);
    if (paymentMethod == StudentPaymentMethodBankCard) {
        paymentMethodNumber = @(4);
    } else if (paymentMethod == StudentPaymentMethodFql) {
        paymentMethodNumber = @(1);
    } else {
        paymentMethodNumber = @(0);
    }
    
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICharges];
    [APIClient postWithParameters:@{@"coach_id":coachId, @"method":paymentMethodNumber, @"product_type":@(productType)} completion:^(NSDictionary *response, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            [Pingpp createPayment:response
                   viewController:viewController
                     appURLScheme:@"hhxc"
                   withCompletion:^(NSString *result, PingppError *error) {
                       if ([result isEqualToString:@"success"]) {
                           if (completion) {
                               completion(YES);
                           }
                       } else {
                           if (completion) {
                               completion(NO);
                           }
                       }
                   }];
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
}


@end
