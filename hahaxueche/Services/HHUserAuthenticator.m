//
//  HHUserAuthenticator.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"
#import "HHLoadingView.h"
#import "HHCoachService.h"

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
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"验证码发送中...",nil)];
    if (isSignup) {
        AVQuery *query = [[AVQuery alloc] initWithClassName:[HHUser parseClassName]];
        [query whereKey:@"username" equalTo:number];
        if ([query getFirstObject]) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"手机号已经注册，请直接登陆！",nil) isError:YES];
            [[HHLoadingView sharedInstance] hideLoadingView];
            return;
        }
    } else {
        AVQuery *query = [[AVQuery alloc] initWithClassName:[HHUser parseClassName]];
        [query whereKey:@"username" equalTo:number];
        if (![query getFirstObject]) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"新用户，请先注册！",nil) isError:YES];
            [[HHLoadingView sharedInstance] hideLoadingView];
            return;
        }

    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:number zone:kAreaCode customIdentifier:nil result:^(NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
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


- (void)verifyPhoneNumberWith:(NSString *)code number:(NSString *)number completion:(HHUserCodeVerificationCompletionBlock)completion {

    [SMSSDK commitVerificationCode:code phoneNumber:number zone:kAreaCode result:^(NSError *error) {
        if (error) {
            completion(NO);
        } else {
            completion(YES);
        }
    }];
}

- (void)createStudentWithStudent:(HHStudent *)student completion:(HHUserGenericCompletionBlock)completion {
    student.studentId = self.currentUser.objectId;
    student.phoneNumber = self.currentUser.mobilePhoneNumber;
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
            if (self.currentStudent.myCoachId){
                [[HHCoachService sharedInstance] fetchCoachWithId:self.currentStudent.myCoachId completion:^(HHCoach *coach, NSError *error) {
                    if (!error) {
                        self.myCoach = coach;
                    }
                }];

            }
        }
        if (completion) {
            completion(student, error);
        }
        
    }];
}


- (void)fetchAuthedStudentAgainWithCompletion:(HHStudentCompletionBlock)completion {
    if (self.currentStudent) {
        [self fetchAuthedStudentWithId:self.currentStudent.studentId completion:completion];
    } else {
        [self fetchAuthedStudentWithId:self.currentUser.objectId completion:completion];
    }
    
}


- (void)fetchAuthedCoachWithId:(NSString *)coachId completion:(HHCoachCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoach parseClassName]];
    [query whereKey:@"coachId" equalTo:coachId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        HHCoach *coach = (HHCoach *)object;
        if (!error) {
            self.currentCoach = coach;
        }
        if (completion) {
            completion(coach, error);
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
    self.currentCoach = nil;
    self.myCoach = nil;
}

@end
