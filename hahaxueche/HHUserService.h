//
//  HHUserService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHUser.h"

typedef void (^HHUserGenericCompletionBlock)(BOOL succeeded, NSError *error);

@interface HHUserService : NSObject

+ (instancetype)sharedInstance;

- (void)requestLoginCodeWithNumber:(NSString *)number completion:(HHUserGenericCompletionBlock)completion;

- (void)signupWithUser:(HHUser *)user completion:(HHUserGenericCompletionBlock)completion;

- (void)verifyPhoneNumberWith:(NSString *)code completion:(HHUserGenericCompletionBlock)completion;

@end
