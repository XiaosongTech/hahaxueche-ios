//
//  HHFreeTrialUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFreeTrialUtility : NSObject

+ (HHFreeTrialUtility *)sharedManager;
- (NSString *)buildFreeTrialURLStringWithCoachId:(NSString *)coachId;

@end
