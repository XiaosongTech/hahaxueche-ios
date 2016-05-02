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
#import "HHCoachSchedule.h"
#import "HHCoachSchedules.h"
#import "HHReview.h"
#import "HHBonusSummary.h"
#import "HHReferrals.h"

typedef void (^HHStudentCompletion)(HHStudent *student, NSError *error);
typedef void (^HHStudentGenericCompletion)(NSError *error);
typedef void (^HHStudentPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);
typedef void (^HHPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);
typedef void (^HHScheduleCompletion)(HHCoachSchedule *schedule, NSError *error);
typedef void (^HHSchedulesCompletion)(HHCoachSchedules *schedules, NSError *error);
typedef void (^HHBonusSummaryCompletion)(HHBonusSummary *bonusSummary, NSError *error);
typedef void (^HHReferralsCompletion)(HHReferrals *referralsObject, NSError *error);


@interface HHStudentService : NSObject

+ (instancetype)sharedInstance;


/**
 Upload authed student avatar
 @param image The image
 @param completion The completion block to execute on completion
 */
- (void)uploadStudentAvatarWithImage:(UIImage *)image completion:(HHStudentCompletion)completion;



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

/**
 Pay a stage money to Coach
 @param paymentStage The paymentStage the student wants to pay
 @param completion The completion block to execute on completion
 */
- (void)payStage:(HHPaymentStage *)paymentStage completion:(HHPurchasedServiceCompletion)completion;

/**
 Book a schedule
 @param scheduleId The ID of the schedule
 @param completion The completion block to execute on completion
 */
- (void)bookScheduleWithId:(NSString *)scheduleId completion:(HHScheduleCompletion)completion;


/**
 Fetch student schedules
 @param studentId The ID of the authed student
 @param scheduleType The type of schedule (0 - coach future schedules; 1 - student booked schedules)
 @param completion The completion block to execute on completion
 */
- (void)fetchScheduleWithId:(NSString *)studentId scheduleType:(NSNumber *)scheduleType completion:(HHSchedulesCompletion)completion;


/**
 Fetch more student schedules
 @param URL The URL of next page
 @param completion The completion block to execute on completion
 */
- (void)fetchScheduleWithURL:(NSString *)URL completion:(HHSchedulesCompletion)completion;

/**
 Cancel booked schedule
 @param scheduleId The ID of the schedule
 @param completion The completion block to execute on completion
 */
- (void)cancelScheduleWithId:(NSString *)scheduleId completion:(HHStudentGenericCompletion)completion;

/**
 Review coach schedule
 @param scheduleId The ID of the schedule
 @param rating The rating number (1.0 - 5.0)
 @param completion The completion block to execute on completion
 */
- (void)reviewScheduleWithId:(NSString *)scheduleId rating:(NSNumber *)rating completion:(HHScheduleCompletion)completion;

/**
 Fetch authed student bonus summary
 @param completion The completion block to execute on completion
 */
- (void)fetchBonusSummaryWithCompletion:(HHBonusSummaryCompletion)completion;

/**
 Fetch authed student referrals
 @param completion The completion block to execute on completion
 */
- (void)fetchReferralsWithCompletion:(HHReferralsCompletion)completion;

/**
 Fetch authed student referrals
 @param URL The URL of next page
 @param completion The completion block to execute on completion
 */
- (void)fetchMoreReferralsWithURL:(NSString *)URL completion:(HHReferralsCompletion)completion;


@end
