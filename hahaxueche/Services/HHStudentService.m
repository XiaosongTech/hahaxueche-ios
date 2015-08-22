//
//  HHStudentService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStudentService.h"
#import "HHUserAuthenticator.h"

@implementation HHStudentService

+ (HHStudentService *)sharedInstance {
    static HHStudentService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHStudentService alloc] init];
    });
    
    return sharedInstance;
}

-(void)fetchStudentWithId:(NSString *)studentId completion:(HHStudentCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHStudent parseClassName]];
    [query whereKey:@"studentId" equalTo:studentId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (completion) {
            HHStudent *student = (HHStudent *)object;
            completion(student, error);
        }
    }];
}

- (void)bookTimeSlotsWithSchedules:(NSArray *)schedules student:(HHStudent *)student coachId:(NSString *)coachId completion:(HHStudentBookCompletionBlock)completion {
    
    HHStudent *copiedStudent = [student mutableCopy];
    NSArray *copiedSchedules = [NSArray arrayWithArray:schedules];
    int i = 0;
    for (HHCoachSchedule *schedule in copiedSchedules) {
        if (schedule.reservedStudents) {
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:schedule.reservedStudents];
            [newArray addObject:student.studentId];
            schedule.reservedStudents = newArray;
        } else {
            NSArray *reservedStudents = @[student.studentId];
            schedule.reservedStudents = reservedStudents;
        }
        if ([schedule save]) {
            if (copiedStudent.myReservation) {
                NSMutableArray *newArray = [NSMutableArray arrayWithArray:copiedStudent.myReservation];
                [newArray addObject:schedule.objectId];
                copiedStudent.myReservation = newArray;
            } else {
                NSMutableArray *reservations = [NSMutableArray arrayWithObject:schedule.objectId];
                copiedStudent.myReservation = reservations;
            }
            i++;
        }
    }
    if (i == 0) {
        if (completion) {
            completion(NO, 0);
        }
        return;
    }
    [copiedStudent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (completion) {
                completion(YES, i);
            }
        } else {
            if (completion) {
                completion(NO, 0);
            }
        }
    }];
}

- (void)cancelAppointmentWithSchedule:(HHCoachSchedule *)schedule completion:(HHStudentCancelAppointmentCompletionBlock)completion {
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

@end
