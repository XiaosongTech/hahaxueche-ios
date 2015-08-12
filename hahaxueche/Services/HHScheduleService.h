//
//  HHScheduleService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHCoachSchedule.h"

typedef void (^HHSchedulesCompletionBlock)(NSArray *objects, NSInteger totalResults, NSError *error);

@interface HHScheduleService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchCoachSchedulesWithCoachId:(NSString *)coachId skip:(NSInteger)skip completion:(HHSchedulesCompletionBlock)completion;

@end
