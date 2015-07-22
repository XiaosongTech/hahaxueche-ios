//
//  HHCoachService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHCoach.h"

typedef void (^HHCoachesArrayCompletionBlock)(NSArray *objects, NSError *error);
typedef void (^HHCoachCompletionBlock)(HHCoach *coach, NSError *error);

@interface HHCoachService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchCoachesWithTraningFieldIds:(NSArray *)fieldIds startIndex:(NSInteger)startIndex completion:(HHCoachesArrayCompletionBlock)completion;

- (void)fetchCoachWithId:(NSString *)coachId completion:(HHCoachCompletionBlock)completion;



@end
