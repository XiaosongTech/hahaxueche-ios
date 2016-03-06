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
typedef void (^HHStudentPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);
typedef void (^HHPurchasedServiceCompletion)(HHPurchasedService *purchasedService, NSError *error);


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


@end
