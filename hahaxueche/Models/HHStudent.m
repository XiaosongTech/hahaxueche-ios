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


+ (NSString *)parseClassName {
    return @"Student";
}


@end
