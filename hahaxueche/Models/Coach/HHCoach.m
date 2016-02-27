//
//  HHCoach.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoach.h"
#import "HHConstantsStore.h"

@implementation HHCoach

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"userId": @"user_id",
             @"coachId": @"id",
             @"avatarUrl": @"avatar_url",
             @"cityId": @"city_id",
             @"averageRating": @"average_rating",
             @"price":@"coach_group.training_cost",
             @"marketPrice":@"coach_group.market_price",
             @"experienceYear":@"experiences",
             @"reviewCount":@"review_count",
             @"skillLevel":@"skill_level",
             @"totalStudentCount":@"total_student_count",
             @"activeStudentCount": @"active_student_count",
             @"satisfactionRate":@"satisfaction_rate",
             @"consultant":@"consultant",
             @"peerCoaches":@"peer_coaches",
             @"bio":@"bio",
             @"cellPhone":@"cell_phone",
             @"fieldId":@"coach_group.field_id",
             @"licenseType":@"license_type",
             @"serviceType":@"service_type",
             
             };
}

+ (NSValueTransformer *)peerCoachesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCoach class]];
}

- (BOOL)isGoldenCoach {
    if ([self.skillLevel integerValue] == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)licenseTypesName {
    if ([self.licenseType integerValue] == 1) {
        return @"C1手动档";
    } else if ([self.licenseType integerValue] == 2) {
        return @"C2自动档";
    } else {
        return @"C1手动档，C2自动挡";
    }
}

- (NSString *)satistactionString {
    return [NSString stringWithFormat:@"%@%%", [self.satisfactionRate stringValue]];
}

- (NSString *)skillLevelString {
    if ([self isGoldenCoach]) {
        return @"金牌教练";
    } else {
        return @"优秀教练";
    }
}

- (HHField *)getCoachField {
    return [[HHConstantsStore sharedInstance] getFieldWithId:self.fieldId];
}

- (NSString *)serviceTypesName {
    if ([self.serviceType integerValue] == 1) {
        return @"科目二";
    } else if ([self.serviceType integerValue] == 2) {
        return @"科目三";
    } else if ([self.serviceType integerValue] == 3) {
        return @"科目二，科目三";
    } else {
        return nil;
    }
}

@end
