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
@dynamic myCoach;
@dynamic city;
@dynamic province;


+ (NSString *)parseClassName {
    return @"Student";
}


@end
