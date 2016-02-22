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

@end
