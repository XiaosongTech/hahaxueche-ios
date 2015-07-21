//
//  HHCoach.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/18/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+Subclass.h"

#define kTrainingFieldIdKey @"trainingFieldId"
#define kCoachIdKey @"coachId"


@interface HHCoach : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, copy) NSString *experienceYear;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSNumber *coachedStudentAmount;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSNumber *averageServiceRating;
@property (nonatomic, copy) NSNumber *averageSkillRating;
@property (nonatomic, copy) NSNumber *totalReviewAmount;
@property (nonatomic, copy) NSNumber *currentStudentAmount;
@property (nonatomic, copy) NSString *trainingFieldId;

@end