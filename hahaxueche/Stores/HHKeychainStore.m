//
//  HHKeychainStore.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHKeychainStore.h"
#import "HHUserAuthService.h"

static NSString *const serviceName = @"hahaxueche";

@implementation HHKeychainStore

+ (BOOL)saveAccessToken:(NSString *)accessToken forUserId:(NSString *)userId {
    return [SSKeychain setPassword:accessToken forService:serviceName account:userId];
}

+ (BOOL)deleteSavedUser {
    HHUser *user = [[HHUserAuthService sharedInstance] getSavedUser];
    return [SSKeychain deletePasswordForService:serviceName account:user.userId];
}

+ (NSString *)getSavedAccessToken {
    HHUser *user = [[HHUserAuthService sharedInstance] getSavedUser];
    return [SSKeychain passwordForService:serviceName account:user.userId];
}

@end
