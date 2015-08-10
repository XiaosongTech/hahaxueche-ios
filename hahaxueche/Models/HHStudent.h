//
//  HHStudent.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/18/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "HHCoach.h"
#import "AVObject+Subclass.h"

#define kStudentIdKey @"studentId"

@interface HHStudent : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *myCoachId;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSArray *myReservation;



@end
