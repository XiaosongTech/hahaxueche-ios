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
#import "HHPersonalCoaches.h"
#import "HHPersonalCoachFilters.h"
#import "HHPersonalCoachSortView.h"
#import "HHPersonalCoach.h"


typedef void (^HHCoachListCompletion)(HHCoaches *coaches, NSError *error);
typedef void (^HHCoachCompletion)(HHCoach *coach, NSError *error);
typedef void (^HHCoachReviewListCompletion)(HHReviews *reviews, NSError *error);
typedef void (^HHCoachCheckFollowedCompletion)(BOOL followed);
typedef void (^HHCoachGenericCompletion)(NSError *error);
typedef void (^HHCoachReviewCompletion)(HHReview *review, NSError *error);
typedef void (^HHCoachSearchCompletion)(NSArray *coaches, NSError *error);
typedef void (^HHPersonalCoachListCompletion)(HHPersonalCoaches *coaches, NSError *error);
typedef void (^HHPersonalCoachCompletion)(HHPersonalCoach *coach, NSError *error);

@interface HHCoachService : NSObject

+ (instancetype)sharedInstance;

/**
 Fetch Coach List
 
 @param completion The completion block to execute on completion
 */
- (void)fetchCoachListWithCityId:(NSNumber *)cityId filters:(HHCoachFilters *)filters sortOption:(SortOption)sortOption userLocation:(NSArray *)userLocation fields:(NSArray *)fields perPage:(NSNumber *)perPage completion:(HHCoachListCompletion)completion;

/**
 Fetch Next Page Coach List
 @param URL The next page path from backend
 @param completion The completion block to execute on completion
 */
- (void)fetchNextPageCoachListWithURL:(NSString *)URL completion:(HHCoachListCompletion)completion;


/**
 Make a Review
 @param coachUserId The userId of the coach object (not coachId)
 @param paymentStage The paymentStage the review relates to
 @param rating The rating of the review
 @param comment The comment of the review
 @param completion The completion block to execute on completion
 */
- (void)makeReviewWithCoachUserId:(NSString *)coachUserId paymentStage:(NSNumber *)paymentStage rating:(NSNumber *)rating comment:(NSString *)comment completion:(HHCoachReviewCompletion)completion;

/**
 Fetch Coach's Reviews
 @param coachUserId The userId of the coach object (not coachId)
 @param completion The completion block to execute on completion
 */
- (void)fetchReviewsWithUserId:(NSString *)coachUserId completion:(HHCoachReviewListCompletion)completion;

/**
 Fetch Coach's Next page reviews
 @param URL The URL of next page
 @param completion The completion block to execute on completion
 */
- (void)fetchNextPageReviewsWithURL:(NSString *)URL completion:(HHCoachReviewListCompletion)completion;


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

/**
 Pay a stage money to Coach
 @param location The loaction array
 @param completion The completion block to execute on completion
 */
- (void)oneClickFindCoachWithLocation:(NSArray *)location completion:(HHCoachCompletion)completion;

/**
 Search Coach
 @param keyword The keyword of the search
 @param completion The completion block to execute on completion
 */
- (void)searchCoachWithKeyword:(NSString *)keyword completion:(HHCoachSearchCompletion)completion;

/**
 Get personal coach list
 @param filters The filters
 @param sortOption The sort option
 @param completion The completion block to execute on completion
 */
- (void)fetchPersoanlCoachWithFilters:(HHPersonalCoachFilters *)filters sortOption:(PersonalCoachSortOption)sortOption completion:(HHPersonalCoachListCompletion)completion;

/**
 Get more personal coach
 @param url The url
 @param completion The completion block to execute on completion
 */
- (void)getMorePersonalCoachWithURL:(NSString *)url completion:(HHPersonalCoachListCompletion) completion;

/**
Get personal coach with coach_id
@param coachId The id of the coach
@param completion The completion block to execute on completion
*/
- (void)fetchPersoanlCoachWithId:(NSString *)coachId completion:(HHPersonalCoachCompletion)completion;

@end
