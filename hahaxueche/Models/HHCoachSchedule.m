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

@end
