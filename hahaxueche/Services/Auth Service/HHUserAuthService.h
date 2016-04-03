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

typedef void (^HHUserErrorCompletion)(NSError *error);
typedef void (^HHUserCompletion)(HHUser *user, NSError *error);
typedef void (^HHStudentCompletion)(HHStudent *student, NSError *error);
typedef void (^HHUserTokenCompletion)(BOOL valid);

@interface HHUserAuthService : NSObject

+ (instancetype)sharedInstance;


/**
 Send verification code to a phone number
 @param number The number we send code to
 @param type Register or Login
 @param completion The completion block to execute on completion
 */
- (void)sendVeriCodeToNumber:(NSString *)number type:(NSString *)type completion:(HHUserErrorCompletion)completion;

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
 Reset PWD for a student
 @param cellPhone The cell phone of the student
 @param veriCode The SMS code we sent to the user
 @param newPWD The newPWD the student sets
 @param completion The completion block to execute on completion
 */
- (void)resetPWDWithCellphone:(NSString *)cellPhone veriCode:(NSString *)veriCode newPWD:(NSString *)newPWD completion:(HHUserErrorCompletion)completion;

/**
 Log out the authed student
*/
- (void)logOutWithCompletion:(HHUserErrorCompletion)completion;


/**
 Return a HHUser object that is saved locally
*/
- (HHUser *)getSavedUser;


/**
 Save a HHUSer object locally
 @param user The authed user object
 */
- (void)saveAuthedUser:(HHUser *)user;

/**
 Check a token if it's valid
 @param cellPhone The cellphone of the user
 @completion The completion block to execute on completion
 */
- (void)isTokenValid:(NSString *)cellPhone completion:(HHUserTokenCompletion)completion;



@end
