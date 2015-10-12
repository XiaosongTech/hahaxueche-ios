//
//  HHCoachSchedule.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachSchedule.h"

@implementation HHCoachSchedule

@dynamic reservedStudents;
@dynamic course;
@dynamic startDateTime;
@dynamic endDateTime;
@dynamic coachId;

+ (NSString *)parseClassName {
    return @"Schedule";
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    HHCoachSchedule *newSchedule = [[HHCoachSchedule alloc] init];
    newSchedule.objectId = self.objectId;
    newSchedule.coachId = self.coachId;
    newSchedule.startDateTime = self.startDateTime;
    newSchedule.endDateTime = self.endDateTime;
    newSchedule.reservedStudents = [self.reservedStudents mutableCopy];;
    newSchedule.course = self.course;
    return newSchedule;
}

@end
