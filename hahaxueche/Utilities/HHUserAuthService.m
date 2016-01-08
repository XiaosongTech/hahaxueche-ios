//
//  HHLoginRegisterService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUserAuthService.h"

@implementation HHUserAuthService

+ (instancetype)sharedInstance {
    static HHUserAuthService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHUserAuthService alloc] init];
    });
    
    return sharedInstance;
}

- (void)sendVeriCodeToNumber:(NSString *)number completion:(HHSendVeriCodeCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPISendVeriCodePath];
    [APIClient postWithParameters:@{@"cell_phone":number} completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];

}

- (void)createUserWithNumber:(NSString *)number veriCode:(NSString *)veriCode password:(NSString *)password completion:(HHUserCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIUserPath];
    [APIClient postWithParameters:@{@"cell_phone":number, @"auth_token":veriCode, @"password":password} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHUser *user = [[HHUser alloc] initWithDictionary:response error:nil];
            if (completion) {
                completion(user, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    }];
}

@end
