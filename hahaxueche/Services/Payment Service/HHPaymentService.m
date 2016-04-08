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

@implementation HHPaymentService

+ (instancetype)sharedInstance {
    static HHPaymentService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHPaymentService alloc] init];
    });
    
    return sharedInstance;
}

- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion {
    if ([[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray count]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"您已经有购买的教练，无需再次购买教练！"];
        return;
    }
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICharges];
    [APIClient postWithParameters:@{@"coach_id":coachId} completion:^(NSDictionary *response, NSError *error) {
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