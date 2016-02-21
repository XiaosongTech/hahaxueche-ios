//
//  HHStudentService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHStudent.h"

typedef void (^HHStudentCompletion)(HHStudent *student, NSError *error);
typedef void (^HHStudentGenericCompletion)(NSError *error);
typedef void (^HHStudentCheckFollowedCompletion)(BOOL followed);


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

@end
