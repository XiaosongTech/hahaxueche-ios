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
    NSDictionary *filtersParam = [MTLJSONAdapter JSONDictionaryFromModel:filters error:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:filtersParam];
    param[@"city_id"] = cityId;
    //param[@"sort_by"] = @(sortOption);
    param[@"training_field_ids"] = selectedFields;
    param[@"user_location"] = userLocation;
                           
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

@end
