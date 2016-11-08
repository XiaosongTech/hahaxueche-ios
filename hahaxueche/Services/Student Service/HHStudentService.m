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
#import "HHEvent.h"

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
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIStudentWithdrawTransacion];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSMutableArray *data = [NSMutableArray array];
            for (NSDictionary *dic in response) {
                HHWithdraw *withdraw = [MTLJSONAdapter modelOfClass:[HHWithdraw class] fromJSONDictionary:dic error:nil];
                [data addObject:withdraw];
            }
            
            if (completion) {
                completion(data, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)withdrawBonusWithAmount:(NSNumber *)amount completion:(HHWithdrawCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentWithdraw, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient postWithParameters:@{@"amount":amount} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
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

- (void)signupGroupPurchaseWithName:(NSString *)name number:(NSString *)number completion:(HHStudentGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIGroupPurchase];
    [APIClient postWithParameters:@{@"name":name, @"phone":number} completion:^(NSDictionary *response, NSError *error) {
        if(completion) {
            completion(error);
        }
    }];
}

- (void)setupStudentInfoWithStudentId:(NSString *)studentId userName:(NSString *)userName cityId:(NSNumber *)cityId promotionCode:(NSString *)promotionCode completion:(HHStudentCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentPath, studentId]];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"name":userName, @"city_id":cityId}];
    if (promotionCode) {
        param[@"promo_code"] = promotionCode;
    }
    [APIClient putWithParameters:param completion:^(NSDictionary *response, NSError *error) {
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

- (void)likeOrUnlikeCoachWithId:(NSString *)coachId like:(NSNumber *)like completion:(HHLikeCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPILikeCoach, [HHStudentStore sharedInstance].currentStudent.studentId, coachId]];
    [APIClient postWithParameters:@{@"like":like} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoach *coach = [MTLJSONAdapter modelOfClass:[HHCoach class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(coach, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    }];
    
}

- (void)getCityEventsWithId:(NSNumber *)cityId completion:(HHEventsCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIEvents];
    [APIClient getWithParameters:@{@"city_id":cityId} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSArray *data = response;
            NSMutableArray *events = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                [events addObject:[MTLJSONAdapter modelOfClass:[HHEvent class] fromJSONDictionary:dic error:nil]];
            }
            completion(events, nil);
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (NSString *)getStudentQRCodeURL {
    #ifdef DEBUG
        return [NSString stringWithFormat:@"http://staging-api.hahaxueche.net/share/students/%@/image", [HHStudentStore sharedInstance].currentStudent.studentId];
    #else
        return [NSString stringWithFormat:@"http://api.hahaxueche.net/share/students/%@/image", [HHStudentStore sharedInstance].currentStudent.studentId];
    #endif
}

- (void)addBankCardToStudent:(HHBankCard *)card completion:(HHCardCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIBankCards];
    NSDictionary *dic = @{@"name":card.cardHolderName, @"card_number":card.cardNumber, @"open_bank_code":card.bankCode, @"transferable_type":@"Student", @"transferable_id":[HHStudentStore sharedInstance].currentStudent.studentId};
    [APIClient postWithParameters:dic completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHBankCard *card = [MTLJSONAdapter modelOfClass:[HHBankCard class] fromJSONDictionary:response error:nil];
            [HHStudentStore sharedInstance].currentStudent.bankCard = card;
            if (completion) {
                completion(card, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)getMyAdvisorWithCompletion:(HHAdvisorCompletion)completion {
    if ([HHStudentStore sharedInstance].currentStudent.myAdvisor) {
        if (completion) {
            completion([HHStudentStore sharedInstance].currentStudent.myAdvisor, nil);
            return;
        }
    }
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIAdvisor];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([HHStudentStore sharedInstance].currentStudent.studentId) {
        param[@"student_id"] = [HHStudentStore sharedInstance].currentStudent.studentId;
    }
    [APIClient getWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHAdvisor *advisor = [MTLJSONAdapter modelOfClass:[HHAdvisor class] fromJSONDictionary:response error:nil];
            [HHStudentStore sharedInstance].currentStudent.myAdvisor = advisor;
            if (completion) {
                completion(advisor, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)likeOrUnlikePersonalCoachWithId:(NSString *)coachId like:(NSNumber *)like completion:(HHLikePersonalCoachCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPILikePersonalCoach, [HHStudentStore sharedInstance].currentStudent.studentId, coachId]];
    [APIClient postWithParameters:@{@"like":like} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHPersonalCoach *coach = [MTLJSONAdapter modelOfClass:[HHPersonalCoach class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(coach, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    }];

}

@end
