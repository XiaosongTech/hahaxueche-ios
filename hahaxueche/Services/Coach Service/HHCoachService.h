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
#import "HHCoaches.h"
#import "HHReviews.h"
#import "HHReview.h"

typedef void (^HHCoachListCompletion)(HHCoaches *coaches, NSError *error);
typedef void (^HHCoachCompletion)(HHCoach *coach, NSError *error);
typedef void (^HHCoachReviewListCompletion)(HHReviews *reviews, NSError *error);

@interface HHCoachService : NSObject

+ (instancetype)sharedInstance;

/**
 Fetch Coach List
 
 @param completion The completion block to execute on completion
 */
- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHCoachFilters *)filters sortOption:(SortOption)sortOption fields:(NSArray *)selectedFields userLocation:(NSArray *)userLocation completion:(HHCoachListCompletion)completion;

/**
 Fetch Next Page Coach List
 @param URL The next page path from backend
 @param completion The completion block to execute on completion
 */
- (void)fetchNextPageCoachListWithURL:(NSString *)URL completion:(HHCoachListCompletion)completion;


/**
 Fetch Coach's Reviews
 @param coachUserId The userId of the coach object (not coachId)
 @param completion The completion block to execute on completion
 */
- (void)fetchReviewsWithUserId:(NSString *)coachUserId completion:(HHCoachReviewListCompletion)completion;


/**
 Fetch Coach
 @param coachId The coachId of the coach 
 @param completion The completion block to execute on completion
 */
- (void)fetchCoachWithId:(NSString *)coachId completion:(HHCoachCompletion)completion;


@end
