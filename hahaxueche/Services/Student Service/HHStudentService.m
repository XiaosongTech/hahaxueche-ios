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
#import "UIImage+HHImage.h"

static NSString *const kUserObjectKey = @"kUserObjectKey";

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
    UIImage *scaleDownedImage = [UIImage imageWithImage:image scaledToWidth:300.0f];
    [APIClient uploadImage:scaleDownedImage completion:^(NSDictionary *response, NSError *error) {
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


- (void)fetchStudentWithId:(NSString *)studentId completion:(HHStudentCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudent, studentId]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHStudent *student = [MTLJSONAdapter modelOfClass:[HHStudent class] fromJSONDictionary:response error:nil];
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

- (void)payStage:(HHPaymentStage *)paymentStage completion:(HHPurchasedServiceCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIStudentPurchasedService];
    [APIClient putWithParameters:@{@"payment_stage":paymentStage.stageNumber} completion:^(NSDictionary *response, NSError *error) {
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

- (void)bookScheduleWithId:(NSString *)scheduleId completion:(HHScheduleCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIBookSchedule, [HHStudentStore sharedInstance].currentStudent.studentId, scheduleId]];
    [APIClient postWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoachSchedule *schedule = [MTLJSONAdapter modelOfClass:[HHCoachSchedule class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(schedule, nil);
            }
            
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchScheduleWithId:(NSString *)studentId scheduleType:(NSNumber *)scheduleType completion:(HHSchedulesCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentSchedule, studentId]];
    [APIClient getWithParameters:@{@"booked":scheduleType} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoachSchedules *schedules = [MTLJSONAdapter modelOfClass:[HHCoachSchedules class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(schedules, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchScheduleWithURL:(NSString *)URL completion:(HHSchedulesCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoachSchedules *schedules = [MTLJSONAdapter modelOfClass:[HHCoachSchedules class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(schedules, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)cancelScheduleWithId:(NSString *)scheduleId completion:(HHStudentGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentUnschedule, [HHStudentStore sharedInstance].currentStudent.studentId, scheduleId]];
    [APIClient postWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)reviewScheduleWithId:(NSString *)scheduleId rating:(NSNumber *)rating completion:(HHScheduleCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentReviewSchedule, [HHStudentStore sharedInstance].currentStudent.studentId, scheduleId]];
    [APIClient postWithParameters:@{@"rating":rating} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoachSchedule *schedule = [MTLJSONAdapter modelOfClass:[HHCoachSchedule class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(schedule, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }

    }];
    
}

- (void)fetchBonusSummaryWithCompletion:(HHBonusSummaryCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentBonusSummary, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHBonusSummary *bonusSummary = [MTLJSONAdapter modelOfClass:[HHBonusSummary class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(bonusSummary, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

-(void)fetchReferralsWithCompletion:(HHReferralsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentReferees, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHReferrals *referrals = [MTLJSONAdapter modelOfClass:[HHReferrals class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(referrals, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];

}

- (void)fetchMoreReferralsWithURL:(NSString *)URL completion:(HHReferralsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHReferrals *referrals = [MTLJSONAdapter modelOfClass:[HHReferrals class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(referrals, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchWithdrawTransactionWithCompletion:(HHWithdrawsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentWithdrawTransacion, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHWithdraws *withdraws = [MTLJSONAdapter modelOfClass:[HHWithdraws class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(withdraws, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchMoreWithdrawTransactionsWithURL:(NSString *)URL completion:(HHWithdrawsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
           HHWithdraws *withdraws = [MTLJSONAdapter modelOfClass:[HHWithdraws class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(withdraws, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)withdrawBonusWithAmount:(NSNumber *)amount accountName:(NSString *)accountName account:(NSString *)account completion:(HHWithdrawCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentWithdraw, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient postWithParameters:@{@"account":account, @"account_owner_name":accountName, @"amount":amount} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHWithdraw *withdraw = [MTLJSONAdapter modelOfClass:[HHWithdraw class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(withdraw, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];

}

- (void)signupGroupPurchaseWithName:(NSString *)name number:(NSString *)number completion:(HHStudentGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIGroupPurchase];
    [APIClient postWithParameters:@{@"name":name, @"phone":number} completion:^(NSDictionary *response, NSError *error) {
        if(completion) {
            completion(error);
        }
    }];
}

- (void)setupStudentInfoWithStudentId:(NSString *)studentId userName:(NSString *)userName cityId:(NSNumber *)cityId completion:(HHStudentCompletion)completion {
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


@end
