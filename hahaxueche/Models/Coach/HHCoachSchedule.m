//
//  HHCoachSchedule.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachSchedule.h"
#import "HHStudent.h"
#import "HHFormatUtility.h"

@implementation HHCoachSchedule

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"scheduleId": @"id",
             @"startTime": @"start_time",
             @"endTime": @"end_time",
             @"maxStudentCount": @"max_st_count",
             @"registeredStudentCount": @"registered_st_count",
             @"reviewedStudentCount": @"reviewed_st_count",
             @"registeredStudents":@"registered_students",
             @"serviceType":@"service_type",
             @"coach":@"coach",
             @"status":@"status",
             };
}

+ (NSValueTransformer *)registeredStudentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHStudent class]];
}

+ (NSValueTransformer *)coachJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HHCoach class]];
}

+ (NSValueTransformer *)startTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)endTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (NSString *)getCourseName {
    if ([self.serviceType integerValue] == 1) {
        return @"科目二";
    } else {
        return @"科目三";
    }
}

- (NSString *)getScheduleDate {
    return [[HHFormatUtility chineseFullDateFormatter] stringFromDate:self.startTime];
}

@end
