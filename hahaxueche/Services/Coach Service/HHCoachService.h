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
typedef void (^HHCoachCheckFollowedCompletion)(BOOL followed);
typedef void (^HHCoachGenericCompletion)(NSError *error);

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

/**
 Follow a Coach
 @param coachUserId The userId of the coach
 @param completion The completion block to execute on completion
 */
- (void)followCoach:(NSString *)coachUserId completion:(HHCoachGenericCompletion)completion;

/**
 Unfollow a Coach
 @param coachUserId The userId of the coach
 @param completion The completion block to execute on completion
 */
- (void)unfollowCoach:(NSString *)coachUserId completion:(HHCoachGenericCompletion)completion;

/**
 Check if the student already follows a coach
 @param coachUserId The userId of the coach
 @param completion The completion block to execute on completion
 */
- (void)checkFollowedCoach:(NSString *)coachUserId completion:(HHCoachCheckFollowedCompletion)completion;

/**
 Fetch followed coach list
 @param completion The completion block to execute on completion
 */
- (void)fetchFollowedCoachListWithCompletion:(HHCoachListCompletion)completion;


/**
 Try a coach service
 @param coacId The id of the coach
 @param name The name of the guest/student
 @param number The number of the guest/student
 @param firstDate The first date
 @param secondDate The secondDate
 @param completion The completion block to execute on completion
 */
- (void)tryCoachWithId:(NSString *)coachId name:(NSString *)name number:(NSString *)number firstDate:(NSString *)firstDate secondDate:(NSString *)secondDate completion:(HHCoachGenericCompletion)completion;

@end
