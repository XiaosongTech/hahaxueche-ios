//
//  HHEventTrackingManager.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHEventTrackingManager : NSObject

+ (HHEventTrackingManager *)sharedManager;

- (void)eventTriggeredWithId:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
