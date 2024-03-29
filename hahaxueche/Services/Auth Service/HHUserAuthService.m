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

- (void)sendVeriCodeToNumber:(NSString *)number type:(NSString *)type completion:(HHUserErrorCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPISendVeriCodePath];
    [APIClient postWithParameters:@{@"cell_phone":number, @"type":type} completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];

}

- (void)createUserWithNumber:(NSString *)number veriCode:(NSString *)veriCode password:(NSString *)password refererId:(NSString *)refererId completion:(HHUserCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIUserPath];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"cell_phone":number, @"auth_token":veriCode, @"password":password, @"user_type":@"student", @"source":@(0)}];
    if (refererId) {
        param[@"referer_id"] = refererId;
    }
    [APIClient postWithParameters:param completion:^(NSDictionary *response, NSError *error) {
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
            if (user.student) {
                [self postAuthActionsWithUser:user];
                if (completion) {
                    completion(user.student, nil);
                }
            } else {
                if (completion) {
                    completion(nil, nil);
                }
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
            [HHStudentStore sharedInstance].currentStudent = nil;
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

- (void)resetPWDWithCellphone:(NSString *)cellPhone veriCode:(NSString *)veriCode newPWD:(NSString *)newPWD completion:(HHUserErrorCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIResetPWDPath];
    NSDictionary *param = @{@"cell_phone":cellPhone, @"auth_token":veriCode, @"password":newPWD, @"password_confirmation":newPWD};
    [APIClient postWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)postAuthActionsWithUser:(HHUser *)user {
    NSString *token = [user.session.accessToken mutableCopy];
    user.session.accessToken = nil;
    [self saveAuthedUser:user];
    [HHStudentStore sharedInstance].currentStudent = user.student;
    [HHKeychainStore saveAccessToken:token forUserId:user.userId];
    
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

- (void)isTokenValid:(NSString *)cellPhone completion:(HHUserTokenCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIToken];
    [APIClient postWithParameters:@{@"cell_phone":cellPhone} completion:^(NSDictionary *response, NSError *error) {
        if ([response[@"valid"] isEqual:@(1)]) {
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
}




@end
