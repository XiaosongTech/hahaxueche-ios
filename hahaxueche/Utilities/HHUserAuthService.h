//
//  HHLoginRegisterService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAPIClient.h"
#import "APIPaths.h"
#import "HHUser.h"
#import "HHStudent.h"
#import "HHConstants.h"

typedef void (^HHSendVeriCodeCompletion)(NSError *error);
typedef void (^HHUserCompletion)(HHUser *user, NSError *error);
typedef void (^HHStudentCompletion)(HHStudent *student, NSError *error);

@interface HHUserAuthService : NSObject

+ (instancetype)sharedInstance;


/**
 Send verification code to a phone number
 @param number The number we send code to
 @param completion The completion block to execute on completion
 */
- (void)sendVeriCodeToNumber:(NSString *)number completion:(HHSendVeriCodeCompletion)completion;

/**
 Create a user
 @param number The phone number the user want to use
 @param veriCode The verification code that we sent to the number
 @param password The password the user sets up
 @param completion The completion block to execute on completion
 */
- (void)createUserWithNumber:(NSString *)number veriCode:(NSString *)veriCode password:(NSString *)password completion:(HHUserCompletion)completion;

/**
 Setup personal info of a student
 @param studentId The id of the student
 @param userName The user's full name
 @param cityId The city Id the user selects
 @param avatarURL The url of the student's avatar
 @param completion The completion block to execute on completion
 */
- (void)setupStudentInfoWithStudentId:(NSString *)studentId userName:(NSString *)userName cityId:(NSNumber *)cityId avatarURL:(NSString *)url completion:(HHStudentCompletion)completion;



/**
 Login a student with cell phone and SMS code
 @param cellPhone The cell phone of the student
 @param veriCode The verification code sent by SMS
 @param completion The completion block to execute on completion
 */
- (void)loginWithCellphone:(NSString *)cellPhone veriCode:(NSString *)veriCode completion:(HHStudentCompletion)completion;

/**
 Login a student with cell phone and password
 @param cellPhone The cell phone of the student
 @param password The password of the student
 @param completion The completion block to execute on completion
 */
- (void)loginWithCellphone:(NSString *)cellPhone password:(NSString *)password completion:(HHStudentCompletion)completion;

/**
 Log out the authed student
*/
- (void)logOut;


/**
 Return a HHStudent object that is saved locally
*/
- (HHStudent *)getSavedStudent;


/**
 Save a HHStudent object locally
 @param student The authed student object
 */
- (void)saveAuthedStudent:(HHStudent *)student;



@end
