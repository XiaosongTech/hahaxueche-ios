//
//  HHSMSService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/15/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HHSMSGenericCompletionBlock)(BOOL succeed);

@interface HHSMSService : NSObject

+ (instancetype)sharedInstance;

- (void)sendTryCoachSMSToCoach:(NSString *)coachNumber studentName:(NSString *)name studentNumber:(NSString *)studentNumber completion:(HHSMSGenericCompletionBlock)completion;

- (void)sendTransactionSucceedSMSToCoach:(NSString *)coachNumber studentName:(NSString *)name studentNumber:(NSString *)studentNumber completion:(HHSMSGenericCompletionBlock)completion;


- (void)sendTransactionSucceedSMSToStudent:(NSString *)studentNumber studentName:(NSString *)name coachName:(NSString *)coachName completion:(HHSMSGenericCompletionBlock)completion;

@end
