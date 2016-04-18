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


@end
