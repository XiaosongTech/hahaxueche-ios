//
//  HHEventTrackingManager.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kDidPurchaseCoachServiceEventId = @"DidPurchaseCoachService";
static NSString *const kDidTryCoachEventId = @"DidTryCoach";

@interface HHEventTrackingManager : NSObject

+ (HHEventTrackingManager *)sharedManager;

- (void)studentSignedUpOrLoggedIn:(NSString *)studentId;
- (void)studentLoggedOff;

- (void)sendEventWithId:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
