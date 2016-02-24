//
//  HHStudentService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHStudentService.h"
#import "APIPaths.h"
#import "HHStudentStore.h"
#import "HHAPIClient.h"

@implementation HHStudentService

+ (instancetype)sharedInstance {
    static HHStudentService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHStudentService alloc] init];
    });
    
    return sharedInstance;
}

- (void)uploadStudentAvatarWithImage:(UIImage *)image completion:(HHStudentCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentAvatar, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient uploadImage:image completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHStudent *student = [MTLJSONAdapter modelOfClass:[HHStudent class] fromJSONDictionary:response error:nil];
            [HHStudentStore sharedInstance].currentStudent = student;
            if (completion) {
                completion(student, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    } progress:nil];
}

- (void)followCoach:(NSString *)coachUserId completion:(HHStudentGenericCompletion)completion {
     HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentFollows, coachUserId]];
    [APIClient postWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)unfollowCoach:(NSString *)coachUserId completion:(HHStudentGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentFollows, coachUserId]];
    [APIClient deleteWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)checkFollowedCoach:(NSString *)coachUserId completion:(HHStudentCheckFollowedCompletion)completion {
     HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentFollows, coachUserId]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSNumber *succeed = response[@"result"];
            if (completion) {
                completion([succeed boolValue]);
            }
        }
    }];
}

-(void)tryCoachWithId:(NSString *)coachId name:(NSString *)name number:(NSString *)number firstDate:(NSString *)firstDate secondDate:(NSString *)secondDate completion:(HHStudentGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentTryCoach, coachId]];
    NSDictionary *param = @{@"coach_id":coachId, @"name":name, @"phone_number":number, @"first_time_option":firstDate, @"second_time_option":secondDate};
    [APIClient postWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)fetchPurchasedServiceWithCompletion:(HHStudentPurchasedServiceCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIStudentPurchasedService];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHPurchasedService *purchasedService = [MTLJSONAdapter modelOfClass:[HHPurchasedService class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(purchasedService, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

@end
