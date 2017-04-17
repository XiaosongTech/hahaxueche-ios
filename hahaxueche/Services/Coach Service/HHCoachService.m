//
//  HHCoachService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachService.h"
#import "APIPaths.h"
#import "HHAPIClient.h"
#import "HHConstantsStore.h"
#import "HHStudentStore.h"

@implementation HHCoachService

+ (instancetype)sharedInstance {
    static HHCoachService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHCoachService alloc] init];
    });
    
    return sharedInstance;
}


- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHCoachFilters *)filters sortOption:(SortOption)sortOption userLocation:(NSArray *)userLocation fields:(NSArray *)fields completion:(HHCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICoaches];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"golden_coach_only"] = filters.onlyGoldenCoach;
    param[@"vip_only"] = filters.onlyVIPCoach;
    param[@"city_id"] = cityId;
    param[@"sort_by"] = @(sortOption);

    if ([fields count] > 0) {
        param[@"training_field_ids"] = fields;
    }


    if (userLocation) {
        param[@"user_location"] = userLocation;
    }
    
    HHCity *city = [[HHConstantsStore sharedInstance] getCityWithId:cityId];
    if (![filters.price isEqual:[city.priceRanges lastObject]]) {
        param[@"price"] = filters.price;
    }
    if (![filters.distance isEqual:[city.distanceRanges lastObject]]) {
        param[@"distance"] = filters.distance;
    }
    if ([filters.licenseType integerValue] != 3) {
        param[@"license_type"] = filters.licenseType;
    }
    
    if ([HHStudentStore sharedInstance].currentStudent.studentId) {
        param[@"student_id"] = [HHStudentStore sharedInstance].currentStudent.studentId;
    }
    
    [APIClient getWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoaches *coaches = [MTLJSONAdapter modelOfClass:[HHCoaches class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (coaches, nil);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }
    }];
}

- (void)fetchNextPageCoachListWithURL:(NSString *)URL completion:(HHCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoaches *coaches = [MTLJSONAdapter modelOfClass:[HHCoaches class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (coaches, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchReviewsWithUserId:(NSString *)coachUserId completion:(HHCoachReviewListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIUserReviews, coachUserId]];
    [APIClient getWithParameters:@{@"coach_user_id":coachUserId} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHReviews *reviews = [MTLJSONAdapter modelOfClass:[HHReviews class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(reviews, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)makeReviewWithCoachUserId:(NSString *)coachUserId paymentStage:(NSNumber *)paymentStage rating:(NSNumber *)rating comment:(NSString *)comment completion:(HHCoachReviewCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIUserReviews, coachUserId]];
    [APIClient postWithParameters:@{@"coach_user_id":coachUserId, @"payment_stage":paymentStage, @"rating":rating, @"comment":comment} completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHReview *review = [MTLJSONAdapter modelOfClass:[HHReview class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(review, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchCoachWithId:(NSString *)coachId completion:(HHCoachCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPICoach, coachId]];
    NSMutableDictionary *param;
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        param = [NSMutableDictionary dictionary];
        param[@"student_id"] = [HHStudentStore sharedInstance].currentStudent.studentId;
    }
    [APIClient getWithParameters:param completion:^(NSDictionary *response, NSError *error) {
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

- (void)followCoach:(NSString *)coachUserId completion:(HHCoachGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentFollows, coachUserId]];
    [APIClient postWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)unfollowCoach:(NSString *)coachUserId completion:(HHCoachGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentFollows, coachUserId]];
    [APIClient deleteWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)checkFollowedCoach:(NSString *)coachUserId completion:(HHCoachCheckFollowedCompletion)completion {
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

-(void)tryCoachWithId:(NSString *)coachId name:(NSString *)name number:(NSString *)number firstDate:(NSString *)firstDate secondDate:(NSString *)secondDate completion:(HHCoachGenericCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIStudentTryCoach];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"name":name, @"phone_number":number}];
    if (coachId) {
        param[@"coach_id"] = coachId;
    }
    
    if (firstDate) {
        param[@"first_time_option"] = firstDate;
    }
    
    if (secondDate) {
        param[@"second_time_option"] = secondDate;
    }
    [APIClient postWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)fetchFollowedCoachListWithCompletion:(HHCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIUserFollows];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHCoaches *coaches = [MTLJSONAdapter modelOfClass:[HHCoaches class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (coaches, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }

    }];
}

- (void)fetchNextPageReviewsWithURL:(NSString *)URL completion:(HHCoachReviewListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHReviews *reviews = [MTLJSONAdapter modelOfClass:[HHReviews class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (reviews, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];

}

- (void)oneClickFindCoachWithLocation:(NSArray *)location completion:(HHCoachCompletion)completion {
     HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIBestMatchCoach];
    [APIClient getWithParameters:@{@"user_location":location} completion:^(NSDictionary *response, NSError *error) {
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

- (void)searchCoachWithKeyword:(NSString *)keyword completion:(HHCoachSearchCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICoaches];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"keyword"] = keyword;
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        param[@"student_id"] = [HHStudentStore sharedInstance].currentStudent.studentId;
    }
    [APIClient getWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if(!error) {
            NSMutableArray *coaches = [NSMutableArray array];
            for (NSDictionary *coachDic in response) {
                HHCoach *coach = [MTLJSONAdapter modelOfClass:[HHCoach class] fromJSONDictionary:coachDic error:nil];
                [coaches addObject:coach];
            }
            if (completion) {
                completion(coaches, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchPersoanlCoachWithFilters:(HHPersonalCoachFilters *)filters sortOption:(PersonalCoachSortOption)sortOption completion:(HHPersonalCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIPersonalCoaches];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"license_type"] = filters.licenseType;
    param[@"price_limit"] = filters.priceLimit;
    param[@"city_id"] = [HHStudentStore sharedInstance].currentStudent.cityId;
    param[@"order_by"] = @(sortOption);
    
    if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        param[@"student_id"] = [HHStudentStore sharedInstance].currentStudent.studentId;
    }

    [APIClient getWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if(!error) {
            HHPersonalCoaches *coaches = [MTLJSONAdapter modelOfClass:[HHPersonalCoaches class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (coaches, nil);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }
    }];

}
- (void)getMorePersonalCoachWithURL:(NSString *)url completion:(HHPersonalCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:url completion:^(NSDictionary *response, NSError *error) {
        if(!error) {
            HHPersonalCoaches *coaches = [MTLJSONAdapter modelOfClass:[HHPersonalCoaches class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (coaches, nil);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }

    }];

}

- (void)fetchPersoanlCoachWithId:(NSString *)coachId completion:(HHPersonalCoachCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIPersonalCoach, coachId]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if(!error) {
            HHPersonalCoach *coach = [MTLJSONAdapter modelOfClass:[HHPersonalCoach class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (coach, nil);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }

    }];
}

@end
