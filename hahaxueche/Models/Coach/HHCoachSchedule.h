//
//  HHCoachSchedule.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHCoach.h"

@interface HHCoachSchedule : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *scheduleId;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSDate *endTime;
@property (nonatomic, copy) NSNumber *maxStudentCount;
@property (nonatomic, copy) NSNumber *registeredStudentCount;
@property (nonatomic, copy) NSNumber *reviewedStudentCount;
@property (nonatomic, strong) NSArray *registeredStudents;
@property (nonatomic, copy) NSNumber *serviceType;
@property (nonatomic, copy) NSString *scheduleDate;
@property (nonatomic, copy) HHCoach *coach;
@property (nonatomic, copy) NSNumber *status;

- (NSString *)getCourseName;
- (NSString *)getScheduleDate;

@end
