//
//  HHLoginRegisterService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUserAuthService.h"
#import "HHKeychainStore.h"
#import "HHStudentStore.h"

static NSString *const kUserObjectKey = @"kUserObjectKey";

@implementation HHUserAuthService

+ (instancetype)sharedInstance {
    static HHUserAuthService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHUserAuthService alloc] init];
    });
    
    return sharedInstance;
}

- (void)sendVeriCodeToNumber:(NSString *)number completion:(HHUserErrorCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPISendVeriCodePath];
    [APIClient postWithParameters:@{@"cell_phone":number} completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];

}

- (void)createUserWithNumber:(NSString *)number veriCode:(NSString *)veriCode password:(NSString *)password completion:(HHUserCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIUserPath];
    [APIClient postWithParameters:@{@"cell_phone":number, @"auth_token":veriCode, @"password":password, @"user_type":@"student"} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHUser *user = [MTLJSONAdapter modelOfClass:[HHUser class] fromJSONDictionary:response error:nil];
            [self postAuthActionsWithUser:user];
            if (completion) {
                completion(user, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    }];
}

- (void)setupStudentInfoWithStudentId:(NSString *)studentId userName:(NSString *)userName cityId:(NSNumber *)cityId avatarURL:(NSString *)url completion:(HHStudentCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentPath, studentId]];
    [APIClient putWithParameters:@{@"name":userName, @"city_id":cityId} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHStudent *student = [MTLJSONAdapter modelOfClass:[HHStudent class] fromJSONDictionary:response error:nil];
            HHUser *authedUser = [self getSavedUser];
            authedUser.student = student;
            [self saveAuthedUser:authedUser];
            [HHStudentStore sharedInstance].currentStudent = student;
            if (completion) {
                completion(student, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    }];

}

- (void)loginWithCellphone:(NSString *)cellPhone password:(NSString *)password completion:(HHStudentCompletion)completion {
    [self loginWithCellphone:cellPhone veriCode:nil password:password completion:completion];
}

- (void)loginWithCellphone:(NSString *)cellPhone veriCode:(NSString *)veriCode completion:(HHStudentCompletion)completion {
    [self loginWithCellphone:cellPhone veriCode:veriCode password:nil completion:completion];
}

- (void)loginWithCellphone:(NSString *)cellPhone veriCode:(NSString *)veriCode password:(NSString *)password completion:(HHStudentCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPILoginPath];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cell_phone"] = cellPhone;
    if (veriCode) {
        param[@"auth_token"] = veriCode;
    } else {
        param[@"password"] = password;
    }
    
    [APIClient postWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHUser *user = [MTLJSONAdapter modelOfClass:[HHUser class] fromJSONDictionary:response error:nil];
            [self postAuthActionsWithUser:user];
            if (completion) {
                completion(user.student, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)logOutWithCompletion:(HHUserErrorCompletion)completion {
     HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPILogoutPath, [self getSavedUser].session.sessionId]];
    [APIClient deleteWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            [HHKeychainStore deleteSavedUser];
            [self deleteSavedUser];
            if (completion) {
                completion(nil);
            }
        } else {
            completion(error);
        }
    }];
}

- (void)postAuthActionsWithUser:(HHUser *)user {
    [HHKeychainStore saveAccessToken:user.session.accessToken forUserId:user.userId];
    //just save token in keychain, not user default
    user.session.accessToken = nil;
    [self saveAuthedUser:user];
    [HHStudentStore sharedInstance].currentStudent = user.student;
}

- (HHUser *)getSavedUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *studentData = [defaults objectForKey:kUserObjectKey];
    HHUser *savedUser = [MTLJSONAdapter modelOfClass:[HHUser class] fromJSONDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:studentData] error:nil];
    return savedUser;
}

- (void)saveAuthedUser:(HHUser *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [MTLJSONAdapter JSONDictionaryFromModel:user error:nil];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userDic] forKey:kUserObjectKey];
}

- (void)deleteSavedUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:kUserObjectKey];
}




@end
