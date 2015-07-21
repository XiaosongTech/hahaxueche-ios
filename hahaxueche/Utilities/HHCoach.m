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
@dynamic coachedStudentAmount;
@dynamic images;
@dynamic averageServiceRating;
@dynamic averageSkillRating;
@dynamic totalReviewAmount;
@dynamic currentStudentAmount;
@dynamic trainingFieldId;

+ (NSString *)parseClassName {
    return @"Coach";
}

@end
