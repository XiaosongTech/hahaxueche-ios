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
#import "HHWithdraws.h"
#import "HHBankCard.h"
#import "HHAdvisor.h"
#import "HHPersonalCoach.h"
#import "HHVoucher.h"
#import "HHTestScore.h"

typedef void (^HHStudentCompletion)(HHStudent *student, NSError *error);
typedef void (^HHStudentGenericCompletion)(NSError *error);
typedef void (^HHStudentPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);
typedef void (^HHPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);
typedef void (^HHScheduleCompletion)(HHCoachSchedule *schedule, NSError *error);
typedef void (^HHSchedulesCompletion)(HHCoachSchedules *schedules, NSError *error);
typedef void (^HHBonusSummaryCompletion)(HHBonusSummary *bonusSummary, NSError *error);
typedef void (^HHReferralsCompletion)(HHReferrals *referralsObject, NSError *error);
typedef void (^HHWithdrawsCompletion)(NSArray *withdraws, NSError *error);
typedef void (^HHWithdrawCompletion)(BOOL succeed);
typedef void (^HHLikeCompletion)(HHCoach *coach, NSError *error);
typedef void (^HHLikePersonalCoachCompletion)(HHPersonalCoach *coach, NSError *error);
typedef void (^HHEventsCompletion)(NSArray *events, NSError *error);
typedef void (^HHCardCompletion)(HHBankCard *card, NSError *error);
typedef void (^HHAdvisorCompletion)(HHAdvisor *advisor, NSError *error);
typedef void (^HHVouchersCompletion)(NSArray *vouchers);
typedef void (^HHVoucherCompletion)(HHVoucher *voucher, NSError *error);
typedef void (^HHIDImageCompletion)(NSString *imgURL);
typedef void (^HHAgreementCompletion)(NSURL *url, NSError *error);
typedef void (^HHSignAgreementCompletion)(HHStudent *student, NSError *error);
typedef void (^HHTestResultCompletion)(NSArray *results);
typedef void (^HHSaveTestResultCompletion)(HHTestScore *score);
typedef void (^HHMarketingChannelCompletion)(NSString *code);

@interface HHStudentService : NSObject

+ (instancetype)sharedInstance;


/**
 Upload authed student avatar
 @param image The image
 @param completion The completion block to execute on completion
 */
- (void)uploadStudentAvatarWithImage:(UIImage *)image completion:(HHStudentCompletion)completion;

/**
 Setup personal info of a student
 @param studentId The id of the student
 @param userName The user's full name
 @param cityId The city Id the user selects
 @param promotionCode The promotion code
 @param completion The completion block to execute on completion
 */
- (void)setupStudentInfoWithStudentId:(NSString *)studentId userName:(NSString *)userName cityId:(NSNumber *)cityId promotionCode:(NSString *)promotionCode completion:(HHStudentCompletion)completion;


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

/**
 Fetch withdraw transaction history
 @param completion The completion block to execute on completion
 */
- (void)fetchWithdrawTransactionWithCompletion:(HHWithdrawsCompletion)completion;


/**
 Student withdraw
 @param amount The withdraw amount
 @param completion The completion block to execute on completion
 */
- (void)withdrawBonusWithAmount:(NSNumber *)amount completion:(HHWithdrawCompletion)completion;

/**
 Signup group purchase
 @param name The name of the user
 @param number The phone number of the user
 @param completion The completion block to execute on completion
 */
- (void)signupGroupPurchaseWithName:(NSString *)name number:(NSString *)number completion:(HHStudentGenericCompletion)completion;

/**
 Like/Unlike a coach
 @param like Like or Unlike coach //0=unlike; 1=like
 @param coachId The id of the liked/unliked coach
 @param completion The completion block to execute on completion
 */
- (void)likeOrUnlikeCoachWithId:(NSString *)coachId like:(NSNumber *)like completion:(HHLikeCompletion)completion;

/**
 Get advisor info
 */
- (void)getMyAdvisorWithCompletion:(HHAdvisorCompletion)completion;

/**
 - Add bank card to Student
*/
- (void)addBankCardToStudent:(HHBankCard *)card completion:(HHCardCompletion)completion;


/**
 Like/Unlike a personal coach
 @param like Like or Unlike coach //0=unlike; 1=like
 @param coachId The id of the liked/unliked coach
 @param completion The completion block to execute on completion
 */
- (void)likeOrUnlikePersonalCoachWithId:(NSString *)coachId like:(NSNumber *)like completion:(HHLikePersonalCoachCompletion)completion;

/**
 Get valid vouchers
 @param coachId The id of the liked/unliked coach
 @param completion The completion block to execute on completion
 */
- (void)getValidVouchersWithCoachId:(NSString *)coachId completion:(HHVouchersCompletion)completion;


/**
 Activate a voucher
 @param code The code of voucher
 @param completion The completion block to execute on completion
 */
- (void)activateVoucherWithCode:(NSString *)code completion:(HHVoucherCompletion)completion;


/**
 Upload id img
 @param imamge The id image
 @param side The side of id card
 @param completion The completion block to execute on completion
 */
- (void)uploadIDCardWithImage:(UIImage *)img side:(NSNumber *)side completion:(HHIDImageCompletion)completion;

/**
 Get agreement pdf
 @param completion The completion block to execute on completion
 */
- (void)getAgreementURLWithCompletion:(HHAgreementCompletion)completion;


/**
 Sign agreement
 @param completion The completion block to execute on completion
 */
- (void)signAgreementWithCompletion:(HHSignAgreementCompletion)completion;


/**
 Sign agreement
 @param email The email address
 @param completion The completion block to execute on completion
 */
- (void)sendAgreementWithEmail:(NSString *)email completion:(HHStudentGenericCompletion)completion;


/**
 Save simu test result
 @param score The score of the test
 @param course Course of the test 0=courseOne; 1=courseFour
 @param completion The completion block to execute on completion
 */
- (void)saveTestScore:(NSNumber *)score course:(NSNumber *)course completion:(HHSaveTestResultCompletion)completion;


/**
 Get simu test result
 @param completion The completion block to execute on completion
 */
- (void)getSimuTestResultWithCompletion:(HHTestResultCompletion)completion;


/**
 Get vouchers
 @param type The type of vouchers 1=可叠加 0 不可叠加
 @param coachId The id of specific coach
 @param completion The completion block to execute on completion
 */
- (void)getVouchersWithType:(NSNumber *)type coachId:(NSString *)coachId completion:(HHVouchersCompletion)completion;

/**
 Upload contacts
 @param deviceId The id of device from aliyun push
 @param deviceNumber The number of device 
 @param contacts The array of contacts from this device
 */
- (void)uploadContactWithDeviceId:(NSString *)deviceId deviceNumber:(NSString *)deviceNumber contacts:(NSArray *)contacts;

/**
 Get right promo code for activity web page
 @param originalCode The original promo code
 @param channelId The channel id of expected promo code
 @param completion The completion block to execute on completion
 */
- (void)getMarketingChannelCodeWithCode:(NSString *)originalCode channelId:(NSString *)channelId completion:(HHMarketingChannelCompletion)completion;


/**
 Verify id and name
 @param idNum The id number
 @param name The real name of user
 @param completion The completion block to execute on completion
 */
- (void)verifyIdWithNumber:(NSString *)idNum name:(NSString *)name completion:(HHStudentGenericCompletion)completion;

@end
