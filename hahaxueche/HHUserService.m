//
//  HHUserService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHUserService.h"

#define kAreaCode @"86"

@implementation HHUserService

+ (HHUserService *)sharedInstance {
    static HHUserService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHUserService alloc] init];
    });
    
    return sharedInstance;
}

- (void)requestCodeWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion {
    [SMS_SDK getVerificationCodeBySMSWithPhone:number zone:kAreaCode result:^(SMS_SDKError *error) {
        completion(error);
    }];
}

- (void)signupWithUser:(HHUser *)user completion:(HHUserGenericCompletionBlock)completion {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.currentUser = user;
        if (completion) {
            completion(error);
        }
    }];
}


- (void)verifyPhoneNumberWith:(NSString *)code completion:(HHUserCodeVerificationCompletionBlock)completion {
   [SMS_SDK commitVerifyCode:code result:^(enum SMS_ResponseState state) {
       if (state == SMS_ResponseStateSuccess) {
           if (completion) {
               completion(YES);
           }
       } else {
           if (completion) {
                completion(NO);
           }
       }
   }];

}

- (void)createStudentWithStudent:(HHStudent *)student completion:(HHUserGenericCompletionBlock)completion {
    student.studentId = self.currentUser.objectId;
    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.currentStudent = student;
        if (completion) {
            completion(error);
        }
        
    }];
}

@end
