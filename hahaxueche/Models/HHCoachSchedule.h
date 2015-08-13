//
//  HHCoachSchedule.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+Subclass.h"

@interface HHCoachSchedule : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, strong) NSDate *startDateTime;
@property (nonatomic, strong) NSDate *endDateTime;
@property (nonatomic, copy) NSArray *reservedStudents;
@property (nonatomic, copy) NSString *course;

@end
