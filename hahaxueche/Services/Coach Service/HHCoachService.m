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


- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHFilters *)filters sortOption:(CoachSortOption)sortOption userLocation:(NSArray *)userLocation fields:(NSArray *)fields perPage:(NSNumber *)perPage completion:(HHCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICoaches];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"city_id"] = cityId;
    
    if (sortOption == CoachSortOptionReviewCount) {
        param[@"sort_by"] = @(5);
    } else {
        param[@"sort_by"] = @(sortOption);
    }
    
    
    if ([perPage integerValue]> 0) {
        param[@"per_page"] = perPage;
    } else {
        param[@"per_page"] = @(20);
    }
    

    if ([fields count] > 0) {
        param[@"training_field_ids"] = fields;
    }


    if (userLocation) {
        param[@"user_location"] = userLocation;
    }
    if (filters.priceStart) {
        param[@"price_from"] = filters.priceStart;
    }
    
    if (filters.priceEnd) {
        param[@"price_to"] = filters.priceEnd;
    }
    
    if (filters.distance) {
        param[@"distance"] = filters.distance;
    } else {
        param[@"zone"] = filters.zone;
    }
    if ([filters.licenseType integerValue] != 0) {
        param[@"license_type"] = filters.licenseType;
    }
    
    if ([HHStudentStore sharedInstance].currentStudent.studentId) {
        param[@"student_id"] = [HHStudentStore sharedInstance].currentStudent.studentId;
    }
    
    if (filters.businessArea) {
        param[@"business_area"] = filters.businessArea;
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
    param[@"city_id"] = [HHStudentStore sharedInstance].selectedCityId;
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

- (void)fetchDrivingSchoolListWithCityId:(NSNumber *)cityId filters:(HHFilters *)filters sortOption:(SchoolSortOption)sortOption userLocation:(NSArray *)userLocation perPage:(NSNumber *)perPage completion:(HHSchoolListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIDrivingSchools];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"city_id"] = cityId;
    
    if (sortOption == CoachSortOptionDefault) {
        param[@"sort_by"] = nil;
        param[@"order"] = @"asc";
    } else if (sortOption == CoachSortOptionDistance) {
        param[@"sort_by"] = @"distance";
        param[@"order"] = @"asc";
    } else if (sortOption == CoachSortOptionReviewCount) {
        param[@"sort_by"] = @"review_count";
        param[@"order"] = @"desc";
    } else if (sortOption == CoachSortOptionPrice) {
        param[@"sort_by"] = @"price";
        param[@"order"] = @"asc";
    } else {
        param[@"sort_by"] = nil;
        param[@"order"] = @"asc";
    }
    
    
    
    if ([perPage integerValue]> 0) {
        param[@"per_page"] = perPage;
    } else {
        param[@"per_page"] = @(20);
    }
    
    
    if (userLocation) {
        param[@"user_location"] = userLocation;
    }
    if (filters.priceStart) {
        param[@"price_from"] = filters.priceStart;
    }
    
    if (filters.priceEnd) {
        param[@"price_to"] = filters.priceEnd;
    }
    
    if (filters.distance) {
        param[@"distance"] = filters.distance;
    } else {
        param[@"zone"] = filters.zone;
    }
    if (filters.licenseType) {
        param[@"license_type"] = filters.licenseType;
    }
    
    if (filters.businessArea) {
        param[@"business_area"] = filters.businessArea;
    }
    
    [APIClient getWithParameters:param completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHDrivingSchools *schools = [MTLJSONAdapter modelOfClass:[HHDrivingSchools class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (schools, nil);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }
    }];
}

- (void)fetchNextPageDrivingSchoolListWithURL:(NSString *)URL completion:(HHSchoolListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHDrivingSchools *schools = [MTLJSONAdapter modelOfClass:[HHDrivingSchools class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion (schools, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchDrivingSchoolWithId:(NSNumber *)schoolId completion:(HHSchoolCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIDrivingSchool, [schoolId stringValue]]];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHDrivingSchool *school = [MTLJSONAdapter modelOfClass:[HHDrivingSchool class] fromJSONDictionary:response error:nil];
            if (completion) {
                completion(school, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)fetchDrivingSchoolReviewsWithId:(NSNumber *)schoolId completion:(HHCoachReviewListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIDrivingSchoolReviews, [schoolId stringValue]]];
    [APIClient getWithParameters:@{@"per_page":@(20)} completion:^(NSDictionary *response, NSError *error) {
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

- (void)fetchNextPageDrivingSchoolReviewsWithURL:(NSString *)URL completion:(HHCoachReviewListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClient];
    [APIClient getWithURL:URL completion:^(NSDictionary *response, NSError *error) {
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

- (void)searchSchoolWithKeyword:(NSString *)keyword completion:(HHSchoolSearchCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPIDrivingSchools];
    [APIClient getWithParameters:@{@"name":keyword, @"city_id":[HHStudentStore sharedInstance].selectedCityId, @"per_page":@(50)} completion:^(NSDictionary *response, NSError *error) {
        if(!error) {
            NSMutableArray *coaches = [NSMutableArray array];
            for (NSDictionary *schoolDic in response[@"data"]) {
                HHDrivingSchool *school = [MTLJSONAdapter modelOfClass:[HHDrivingSchool class] fromJSONDictionary:schoolDic error:nil];
                [coaches addObject:school];
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


@end
