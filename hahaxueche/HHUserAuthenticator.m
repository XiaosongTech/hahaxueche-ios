//
//  HHUserAuthenticator.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"

#define kAreaCode @"86"

@implementation HHUserAuthenticator

+ (HHUserAuthenticator *)sharedInstance {
    static HHUserAuthenticator *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHUserAuthenticator alloc] init];
    });
    
    return sharedInstance;
}

- (void)requestCodeWithNumber:(NSString *)number isSignup:(BOOL)isSignup completion:(HHUserGenericCompletionBlock)completion {
    
    if (isSignup) {
        AVQuery *query = [[AVQuery alloc] initWithClassName:[HHUser parseClassName]];
        [query whereKey:@"username" equalTo:number];
        if ([query getFirstObject]) {
            [HHToastUtility showToastWitiTitle:@"手机号已经注册，请直接登陆！" isError:YES];
            return;
        }
    } else {
        AVQuery *query = [[AVQuery alloc] initWithClassName:[HHUser parseClassName]];
        [query whereKey:@"username" equalTo:number];
        if (![query getFirstObject]) {
            [HHToastUtility showToastWitiTitle:@"新用户，请注册！" isError:YES];
            return;
        }

    }
       [SMS_SDK getVerificationCodeBySMSWithPhone:number zone:kAreaCode result:^(SMS_SDKError *error) {
        completion(error);
    }];
}

- (void)signupWithUser:(HHUser *)user completion:(HHUserGenericCompletionBlock)completion {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.currentUser = user;
        }
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
        if (!error) {
            self.currentStudent = student;
        } else {
            [self.currentUser deleteInBackground];
            [self.currentStudent deleteInBackground];
        }
        if (completion) {
            completion(error);
        }
        
    }];
}

- (void)loginWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion {
    [HHUser logInWithUsernameInBackground:number password:number block:^(AVUser *user, NSError *error) {
        if (!error) {
            self.currentUser = (HHUser *)user;
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (void)fetchAuthedStudentWithId:(NSString *)studentId completion:(HHStudentCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHStudent parseClassName]];
    [query whereKey:kStudentIdKey equalTo:studentId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        HHStudent *student = (HHStudent *)object;
        if (!error) {
            self.currentStudent = student;
        }
        if (completion) {
            completion(student, error);
        }
    }];
}

- (void)deleteUser {
    [self.currentUser deleteInBackground];
    [self.currentStudent deleteInBackground];

}


- (void)logout {
    [HHUser logOut];
    self.currentStudent = nil;
    self.currentUser = nil;
}

@end
