//
//  HHScheduleService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScheduleService.h"

@implementation HHScheduleService

+ (HHScheduleService *)sharedInstance {
    static HHScheduleService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHScheduleService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchCoachSchedulesWithCoachId:(NSString *)coachId skip:(NSInteger)skip completion:(HHSchedulesCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    query.limit = 20;
    query.skip = skip;
    [query whereKey:@"coachId" equalTo:coachId];
    [query orderByAscending:@"startDateTime"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion (objects, [query countObjects], error);
        }
    }];
}


@end
