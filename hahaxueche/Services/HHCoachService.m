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


- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHCoachFilters *)filters sortOption:(SortOption)sortOption fields:(NSArray *)selectedFields completion:(HHCoachListCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:kAPICoaches];
    [APIClient getWithParameters:nil completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            if (completion) {
                completion (nil, nil);
            }
        }
    }];
}

@end
