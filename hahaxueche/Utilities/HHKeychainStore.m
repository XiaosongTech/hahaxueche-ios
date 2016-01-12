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

+ (BOOL)saveAccessToken:(NSString *)accessToken forStudentId:(NSString *)studentId {
    return [SSKeychain setPassword:accessToken forService:serviceName account:studentId];
}

+ (BOOL)deleteSavedStudent {
    HHStudent *student = [[HHUserAuthService sharedInstance] getSavedStudent];
    return [SSKeychain deletePasswordForService:serviceName account:student.studentId];
}

+ (NSString *)getSavedAccessToken {
    HHStudent *student = [[HHUserAuthService sharedInstance] getSavedStudent];
    return [SSKeychain passwordForService:serviceName account:student.studentId];
}

@end
