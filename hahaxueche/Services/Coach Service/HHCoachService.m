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

@implementation HHCoachService

+ (instancetype)sharedInstance {
    static HHCoachService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHCoachService alloc] init];
    });
    
    return sharedInstance;
}


- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHCoachFilters *)filters sortOption:(SortOption)sortOption fields:(NSArray *)selectedFields userLocation:(NSArray *)userLocation completion:(HHCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICoaches];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"golden_coach_only"] = filters.onlyGoldenCoach;
    param[@"city_id"] = cityId;
    param[@"sort_by"] = @(sortOption);
    
    if ([selectedFields count]) {
        param[@"training_field_ids"] = selectedFields;
    }

    if (userLocation) {
        param[@"user_location"] = userLocation;
    }
    
    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    if (![filters.price isEqual:[city.priceRanges lastObject]]) {
        param[@"price"] = filters.price;
    }
    if (![filters.distance isEqual:[city.distanceRanges lastObject]]) {
        param[@"distance"] = filters.distance;
    }
    if ([filters.licenseType integerValue] != 3) {
        param[@"license_type"] = filters.licenseType;
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
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
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
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentTryCoach, coachId]];
    NSDictionary *param = @{@"name":name, @"phone_number":number, @"first_time_option":firstDate, @"second_time_option":secondDate};
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
    NSString *encodeURL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [APIClient getWithURL:encodeURL completion:^(NSDictionary *response, NSError *error) {
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


@end
