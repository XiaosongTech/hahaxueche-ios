//
//  HHCoachService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHCoach.h"
#import "HHCoachFilters.h"
#import "HHSortView.h"

typedef void (^HHCoachListCompletion)(NSArray *coaches, NSError *error);

@interface HHCoachService : NSObject

+ (instancetype)sharedInstance;

/**
 Fetch Coach List
 
 @param completion The completion block to execute on completion
 */
- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHCoachFilters *)filters sortOption:(SortOption)sortOption fields:(NSArray *)selectedFields completion:(HHCoachListCompletion)completion;

@end
