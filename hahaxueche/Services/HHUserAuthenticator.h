//
//  HHUserAuthenticator.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHUser.h"
#import "HHStudent.h"
#import "HHCoach.h"
#import <SMS_SDK/SMS_SDK.h>

typedef void (^HHUserGenericCompletionBlock)(NSError *error);
typedef void (^HHUserCodeVerificationCompletionBlock)(BOOL succeed);
typedef void (^HHStudentCompletionBlock)(HHStudent *student, NSError *error);
typedef void (^HHCoachCompletionBlock)(HHCoach *coach, NSError *error);

@interface HHUserAuthenticator : NSObject

@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) HHUser *currentUser;
@property (nonatomic, strong) HHCoach *myCoach;
@property (nonatomic, strong) HHCoach *currentCoach;

+ (instancetype)sharedInstance;

- (void)requestCodeWithNumber:(NSString *)number isSignup:(BOOL)isSignup completion:(HHUserGenericCompletionBlock)completion;

- (void)signupWithUser:(HHUser *)user completion:(HHUserGenericCompletionBlock)completion;

- (void)verifyPhoneNumberWith:(NSString *)code completion:(HHUserCodeVerificationCompletionBlock)completion;

- (void)createStudentWithStudent:(HHStudent *)student completion:(HHUserGenericCompletionBlock)completion;

- (void)fetchAuthedStudentWithId:(NSString *)studentId completion:(HHStudentCompletionBlock)completion;

- (void)fetchAuthedStudentAgainWithCompletion:(HHStudentCompletionBlock)completion;

- (void)fetchAuthedCoachWithId:(NSString *)coachId completion:(HHCoachCompletionBlock)completion;

- (void)loginWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion;

- (void)deleteUser;

- (void)logout;

@end
