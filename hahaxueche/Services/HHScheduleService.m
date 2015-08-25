//
//  HHScheduleService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScheduleService.h"
#import "HHUserAuthenticator.h"

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
        if (!error) {
            for (HHCoachSchedule *schedule in objects) {
                if (schedule.reservedStudents) {
                    NSMutableArray *studentsArray = [NSMutableArray array];
                    for (NSString *studentId in schedule.reservedStudents) {
                        AVQuery *newQuery = [AVQuery queryWithClassName:[HHStudent parseClassName]];
                        [newQuery whereKey:@"studentId" equalTo:studentId];
                        [studentsArray addObject:[newQuery getFirstObject]];
                    }
                    schedule.fullStudents = studentsArray;
                }
               
            }
        }
        if (completion) {
            completion (objects, [query countObjects], error);
        }
        
    }];
}

- (void)fetchAuthedStudentReservationsWithSkip:(NSInteger)skip completion:(HHSchedulesCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    query.limit = 20;
    query.skip = skip;
    if (![[HHUserAuthenticator sharedInstance].currentStudent.myReservation count]) {
        if (completion) {
            completion([NSArray array], 0, nil);
        }
        return;
    }
    [query whereKey:@"objectId" containedIn:[HHUserAuthenticator sharedInstance].currentStudent.myReservation];
    [query orderByAscending:@"startDateTime"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (HHCoachSchedule *schedule in objects) {
                if (schedule.reservedStudents) {
                    NSMutableArray *studentsArray = [NSMutableArray array];
                    for (NSString *studentId in schedule.reservedStudents) {
                        AVQuery *newQuery = [AVQuery queryWithClassName:[HHStudent parseClassName]];
                        [newQuery whereKey:@"studentId" equalTo:studentId];
                        [studentsArray addObject:[newQuery getFirstObject]];
                    }
                    schedule.fullStudents = studentsArray;
                }
                
            }

        }
        if (completion) {
            completion (objects, [query countObjects], error);
        }

    }];
    
}


@end
