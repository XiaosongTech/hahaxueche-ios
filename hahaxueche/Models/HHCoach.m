//
//  HHCoach.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/18/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoach.h"

@implementation HHCoach

@dynamic coachId;
@dynamic fullName;
@dynamic avatarURL;
@dynamic des;
@dynamic experienceYear;
@dynamic course;
@dynamic price;
@dynamic passedStudentAmount;
@dynamic images;
@dynamic totalReviewAmount;
@dynamic currentStudentAmount;
@dynamic trainingFieldId;
@dynamic phoneNumber;
@dynamic averageRating;

+ (NSString *)parseClassName {
    return @"Coach";
}

@end