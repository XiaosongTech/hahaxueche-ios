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

- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId paymentMethod:(StudentPaymentMethod)paymentMethod productType:(CoachProductType)productType voucherId:(NSString *)voucherId inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 0-Alipay; 4-银行卡; 1-分期乐
    NSNumber *paymentMethodNumber = @(0);
    
    switch (paymentMethod) {
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
    if ([paymentMethodNumber isEqual:@(4)]) {
        [Pingpp ignoreResultUrl:YES];
    }
    
    dic[@"coach_id"] = coachId;
    dic[@"method"] = paymentMethodNumber;
    dic[@"product_type"] = @(productType);
    
    if (voucherId) {
        dic[@"voucher_id"] = voucherId;
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


@end
