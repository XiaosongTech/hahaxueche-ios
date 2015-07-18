//
//  HHUserService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHUserService.h"

@implementation HHUserService

+ (HHUserService *)sharedInstance {
    static HHUserService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHUserService alloc] init];
    });
    
    return sharedInstance;
}

- (void)requestLoginCodeWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion {
    [AVUser requestLoginSmsCode:number withBlock:^(BOOL succeeded, NSError *error) {
        if (completion) {
            completion(succeeded, error);
        }
    }];
}

- (void)signupWithUser:(HHUser *)user completion:(HHUserGenericCompletionBlock)completion {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completion) {
            completion(succeeded, error);
        }
    }];
}


- (void)verifyPhoneNumberWith:(NSString *)code completion:(HHUserGenericCompletionBlock)completion {
    [AVUser verifyMobilePhone:code withBlock:^(BOOL succeeded, NSError *error) {
        if (completion) {
            completion(succeeded, error);
        }
    }];

}

@end
