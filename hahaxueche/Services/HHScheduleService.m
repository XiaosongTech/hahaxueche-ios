//
//  HHScheduleService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScheduleService.h"
#import "HHUserAuthenticator.h"
#import "HHUserAuthenticator.h"
#import "NSDate+DateTools.h"

static NSInteger const daysGap = 14;

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
    [query whereKey:@"startDateTime" greaterThanOrEqualTo:[NSDate date]];
    if ([HHUserAuthenticator sharedInstance].currentStudent) {
        NSDate *endDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*daysGap];
        [query whereKey:@"startDateTime" lessThanOrEqualTo:endDate];
    }
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
    [query whereKey:@"startDateTime" greaterThanOrEqualTo:[NSDate date]];
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

- (void)cancelAppointmentWithSchedule:(HHCoachSchedule *)schedule completion:(HHScheduleCompletionBlock)completion {
    NSMutableArray *copiedReservations = [[HHUserAuthenticator sharedInstance].currentStudent.myReservation mutableCopy];
    HHStudent *copiedStudent = [[HHUserAuthenticator sharedInstance].currentStudent mutableCopy];
    HHCoachSchedule *copiedSchedule = [schedule mutableCopy];
    
    NSMutableArray *reservedStudents = [NSMutableArray arrayWithArray:copiedSchedule.reservedStudents];
    for (NSString *studentId in reservedStudents) {
        if ([studentId isEqualToString:copiedStudent.studentId]) {
            [reservedStudents removeObject:studentId];
            break;
        }
    }
    copiedSchedule.reservedStudents = reservedStudents;
    if ([copiedSchedule save]) {
        if ([copiedReservations count]) {
            for (NSString *scheduleId in copiedReservations) {
                if ([scheduleId isEqualToString:schedule.objectId]) {
                    [copiedReservations removeObject:scheduleId];
                    break;
                }
            }
            copiedStudent.myReservation = copiedReservations;
            [copiedStudent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [HHUserAuthenticator sharedInstance].currentStudent = copiedStudent;
                }
                if (completion) {
                    completion(succeeded, error);
                }
            }];
        }
    } else {
        if (completion) {
            completion(NO, nil);
        }
    }
}

- (void)submitSchedule:(HHCoachSchedule *)schedule completion:(HHScheduleCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    query.limit = 50;
    
    [query whereKey:@"coachId" equalTo:schedule.coachId];
    [query whereKey:@"startDateTime" greaterThanOrEqualTo:schedule.startDateTime];
    [query whereKey:@"startDateTime" lessThanOrEqualTo:[schedule.startDateTime dateByAddingSeconds:59]];
    
    [query whereKey:@"endDateTime" greaterThanOrEqualTo:schedule.endDateTime];
    [query whereKey:@"endDateTime" lessThanOrEqualTo:[schedule.endDateTime dateByAddingSeconds:59]];
    [query whereKey:@"course" equalTo:schedule.course];
    if ([query getFirstObject]) {
        [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completion) {
                completion(succeeded, error);
            }
        }];
        return ;
    }
    
    query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    [query whereKey:@"coachId" equalTo:schedule.coachId];
    [query whereKey:@"startDateTime" lessThanOrEqualTo:schedule.startDateTime];
    [query whereKey:@"endDateTime" greaterThanOrEqualTo:schedule.endDateTime];
    if ([query getFirstObject]) {
        if (completion) {
            completion (NO, nil);
        }
        return;
    }
    
    query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    [query whereKey:@"coachId" equalTo:schedule.coachId];
    [query whereKey:@"startDateTime" lessThanOrEqualTo:schedule.startDateTime];
    [query whereKey:@"endDateTime" greaterThanOrEqualTo:schedule.startDateTime];
    if ([query getFirstObject]) {
        if (completion) {
            completion (NO, nil);
        }
        return;
    }
    
    query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    [query whereKey:@"coachId" equalTo:schedule.coachId];
    [query whereKey:@"startDateTime" greaterThanOrEqualTo:schedule.startDateTime];
    [query whereKey:@"endDateTime" lessThanOrEqualTo:schedule.endDateTime];
    if ([query getFirstObject]) {
        if (completion) {
            completion (NO, nil);
        }
        return;
    }
    
    query = [AVQuery queryWithClassName:[HHCoachSchedule parseClassName]];
    [query whereKey:@"coachId" equalTo:schedule.coachId];
    [query whereKey:@"startDateTime" lessThanOrEqualTo:schedule.endDateTime];
    [query whereKey:@"endDateTime" greaterThanOrEqualTo:schedule.endDateTime];
    if ([query getFirstObject]) {
        if (completion) {
            completion (NO, nil);
        }
        return;
    }
    [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completion) {
            completion(succeeded, error);
        }
    }];
}



@end
