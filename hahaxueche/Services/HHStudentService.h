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

typedef void (^HHStudentCompletionBlock)(HHStudent *student, NSError *error);
typedef void (^HHStudentsCompletionBlock)(NSArray *students, NSInteger totalResults, NSError *error);
typedef void (^HHStudentBookCompletionBlock)(BOOL succeed, NSInteger succeedCount);

@interface HHStudentService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchStudentWithId:(NSString *)studentId completion:(HHStudentCompletionBlock)completion;

- (void)bookTimeSlotsWithSchedules:(NSArray *)schedules student:(HHStudent *)student coachId:(NSString *)coachId completion:(HHStudentBookCompletionBlock)completion;

- (void)fetchStudentWithQueryForAuthedCoach:(NSString *)queryText skip:(NSInteger)skip completion:(HHStudentsCompletionBlock)completion;



@end
