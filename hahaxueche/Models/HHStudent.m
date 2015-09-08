//
//  HHStudent.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/18/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStudent.h"

@implementation HHStudent

@dynamic fullName;
@dynamic studentId;
@dynamic avatarURL;
@dynamic myCoachId;
@dynamic city;
@dynamic province;
@dynamic myReservation;
@dynamic phoneNumber;
@dynamic isFinished;

+ (NSString *)parseClassName {
    return @"Student";
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    HHStudent *newStudent = [[HHStudent alloc] init];
    newStudent.objectId = self.objectId;
    newStudent.fullName = self.fullName;
    newStudent.studentId = self.studentId;
    newStudent.avatarURL = self.avatarURL;
    newStudent.myCoachId = self.myCoachId;
    newStudent.city = self.city;
    newStudent.province = self.province;
    newStudent.myReservation = self.myReservation;
    newStudent.phoneNumber = self.phoneNumber;
    newStudent.isFinished = self.isFinished;
    return newStudent;
}

@end
