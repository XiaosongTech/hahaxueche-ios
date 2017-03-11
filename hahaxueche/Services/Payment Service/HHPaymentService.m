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

- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId paymentMethod:(StudentPaymentMethod)paymentMethod productType:(CoachProductType)productType voucherId:(NSString *)voucherId needInsurance:(BOOL)needInsurance inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSNumber *paymentMethodNumber = [self getPaymentMethodForBackend:paymentMethod];

    if ([paymentMethodNumber isEqual:@(4)]) {
        [Pingpp ignoreResultUrl:YES];
    }
    
    dic[@"coach_id"] = coachId;
    dic[@"method"] = paymentMethodNumber;
    dic[@"product_type"] = @(productType);
    
    if (voucherId) {
        dic[@"voucher_id"] = voucherId;
    }
    
    if (needInsurance) {
        dic[@"need_insurance"] = @"true";
    }
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICharges];
    [APIClient postWithParameters:dic completion:^(NSDictionary *response, NSError *error) {
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

- (void)purchaseInsuranceWithpaymentMethod:(StudentPaymentMethod)paymentMethod inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIInsuranceCharges, [HHStudentStore sharedInstance].currentStudent.studentId]];
    NSNumber *paymentMethodNumber = [self getPaymentMethodForBackend:paymentMethod];
   
    if ([paymentMethodNumber isEqual:@(4)]) {
        [Pingpp ignoreResultUrl:YES];
    }

    [APIClient postWithParameters:@{@"method":paymentMethodNumber} completion:^(NSDictionary *response, NSError *error) {
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

- (void)prepayWithType:(NSInteger)type paymentMethod:(StudentPaymentMethod)paymentMethod inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIPrepayCharges];
    NSNumber *paymentMethodNumber = [self getPaymentMethodForBackend:paymentMethod];
    if ([paymentMethodNumber isEqual:@(4)]) {
        [Pingpp ignoreResultUrl:YES];
    }
    [APIClient postWithParameters:@{@"phone":[HHStudentStore sharedInstance].currentStudent.cellPhone, @"event_type":@(type), @"method":paymentMethodNumber} completion:^(NSDictionary *response, NSError *error) {
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

- (NSNumber *)getPaymentMethodForBackend:(StudentPaymentMethod)method {
    NSNumber *paymentMethodNumber = @(0);
    switch (method) {
        case StudentPaymentMethodAlipay: {
            paymentMethodNumber = @(0);
        } break;
            
        case StudentPaymentMethodWechatPay: {
            paymentMethodNumber = @(5);
        } break;
            
        case StudentPaymentMethodBankCard: {
            paymentMethodNumber = @(4);
        } break;
            
        case StudentPaymentMethodFql: {
            paymentMethodNumber = @(1);
        } break;
            
        default: {
            paymentMethodNumber = @(0);
        } break;
    }
    return paymentMethodNumber;
}


@end
