//
//  HHStudentService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHStudent.h"
#import "HHPurchasedService.h"

typedef void (^HHStudentCompletion)(HHStudent *student, NSError *error);
typedef void (^HHStudentGenericCompletion)(NSError *error);
typedef void (^HHStudentCheckFollowedCompletion)(BOOL followed);
typedef void (^HHStudentPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);


@interface HHStudentService : NSObject

+ (instancetype)sharedInstance;


/**
 Upload authed student avatar
 @param image The image
 @param completion The completion block to execute on completion
 */
- (void)uploadStudentAvatarWithImage:(UIImage *)image completion:(HHStudentCompletion)completion;

/**
 Follow a Coach
 @param coachUserId The userId of the coach
 @param completion The completion block to execute on completion
 */
- (void)followCoach:(NSString *)coachUserId completion:(HHStudentGenericCompletion)completion;

/**
 Unfollow a Coach
 @param coachUserId The userId of the coach
 @param completion The completion block to execute on completion
 */
- (void)unfollowCoach:(NSString *)coachUserId completion:(HHStudentGenericCompletion)completion;

/**
 Check if the student already follows a coach
 @param coachUserId The userId of the coach
 @param completion The completion block to execute on completion
 */
- (void)checkFollowedCoach:(NSString *)coachUserId completion:(HHStudentCheckFollowedCompletion)completion;


/**
 Try a coach service
 @param coacId The id of the coach
 @param name The name of the guest/student
 @param number The number of the guest/student
 @param firstDate The first date
 @param secondDate The secondDate
 @param completion The completion block to execute on completion
 */
- (void)tryCoachWithId:(NSString *)coachId name:(NSString *)name number:(NSString *)number firstDate:(NSString *)firstDate secondDate:(NSString *)secondDate completion:(HHStudentGenericCompletion)completion;


/**
 Fetch PurchasedService
 @param completion The completion block to execute on completion
 */
- (void)fetchPurchasedServiceWithCompletion:(HHStudentPurchasedServiceCompletion)completion;


/**
 Fetch a student
 @param studentId The studentId of the student
 @param completion The completion block to execute on completion
 */
- (void)fetchStudentWithId:(NSString *)studentId completion:(HHStudentCompletion)completion;
@end
