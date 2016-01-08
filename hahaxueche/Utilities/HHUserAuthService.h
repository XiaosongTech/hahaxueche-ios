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

typedef void (^HHSendVeriCodeCompletion)(NSError *error);
typedef void (^HHUserCompletion)(HHUser *user, NSError *error);

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

@end
