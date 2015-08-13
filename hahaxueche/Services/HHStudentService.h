//
//  HHStudentService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHStudent.h"
#import "HHCoachSchedule.h"

typedef void (^HHStudentsCompletionBlock)(NSArray *objects, NSError *error);
typedef void (^HHStudentCompletionBlock)(HHStudent *student, NSError *error);
typedef void (^HHStudentBookCompletionBlock)(BOOL succeed, NSInteger succeedCount);

@interface HHStudentService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchStudentsForScheduleWithIds:(NSArray *)studentIds completion:(HHStudentsCompletionBlock)completion;

- (void)fetchStudentWithId:(NSString *)studentId completion:(HHStudentCompletionBlock)completion;

- (void)bookTimeSlotsWithSchedules:(NSArray *)schedules student:(HHStudent *)student coachId:(NSString *)coachId completion:(HHStudentBookCompletionBlock)completion;


@end
