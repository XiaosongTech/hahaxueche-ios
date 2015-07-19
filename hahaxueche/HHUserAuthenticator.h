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
#import <SMS_SDK/SMS_SDK.h>

typedef void (^HHUserGenericCompletionBlock)(NSError *error);
typedef void (^HHUserCodeVerificationCompletionBlock)(BOOL succeed);

@interface HHUserAuthenticator : NSObject

@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) HHUser *currentUser;

+ (instancetype)sharedInstance;

- (void)requestCodeWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion;

- (void)signupWithUser:(HHUser *)user completion:(HHUserGenericCompletionBlock)completion;

- (void)verifyPhoneNumberWith:(NSString *)code completion:(HHUserCodeVerificationCompletionBlock)completion;

- (void)createStudentWithStudent:(HHStudent *)student completion:(HHUserGenericCompletionBlock)completion;

- (void)fetchAuthedStudentWithId:(NSString *)studentId completion:(HHUserGenericCompletionBlock)completion;

- (void)loginWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion;

- (void)logout;

@end
