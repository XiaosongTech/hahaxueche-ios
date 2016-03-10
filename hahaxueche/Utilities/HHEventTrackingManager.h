//
//  HHEventTrackingManager.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kDidPurchaseCoachServiceEventId = @"did_purchase_coach";
static NSString *const kDidTryCoachEventId = @"did_try_coach";
static NSString *const kDidRegisterEventId = @"did_register";

@interface HHEventTrackingManager : NSObject

+ (HHEventTrackingManager *)sharedManager;

- (void)studentSignedUpOrLoggedIn:(NSString *)studentId;
- (void)studentLoggedOff;

- (void)sendEventWithId:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
