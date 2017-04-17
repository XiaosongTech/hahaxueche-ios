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
             @"avatarUrl": @"avatar",
             @"cityId": @"city_id",
             @"averageRating": @"average_rating",
             @"price":@"coach_group.training_cost",
             @"VIPPrice":@"coach_group.vip_price",
             @"c2Price":@"coach_group.c2_price",
             @"c2VIPPrice":@"coach_group.c2_vip_price",
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
             @"images":@"images",
             @"liked":@"liked",
             @"likeCount":@"like_count",
             @"drivingSchool":@"driving_school",
             @"stageThreePassRate":@"stage_three_pass_rate",
             @"stageTwoPassRate":@"stage_two_pass_rate",
             @"averagePassDays":@"average_pass_days",
             @"hasDeposit":@"has_cash_pledge",
             @"cooperationType":@"cooperation_type",
             @"isCheyouWuyou":@"coach_group.group_type",
             @"distance":@"distance",
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


- (NSNumber *)getPriceProductType:(CoachProductType)type {
    switch (type) {
        case CoachProductTypeStandard: {
            return self.price;
        }
            
        case CoachProductTypeVIP: {
            return self.VIPPrice;
        }
            
        case CoachProductTypeC2Standard: {
            return self.c2Price;
        }
            
        case CoachProductTypeC2VIP: {
            return self.c2VIPPrice;
        }
            
        case CoachProductTypeC1Wuyou: {
            return @([self.price floatValue] + [[[HHConstantsStore sharedInstance] getInsuranceWithType:0] floatValue]);
        }
            
        case CoachProductTypeC2Wuyou: {
            return @([self.c2Price floatValue] + [[[HHConstantsStore sharedInstance] getInsuranceWithType:0] floatValue]);
        }
            
        default:
            return self.price;
    }
}

- (HHDrivingSchool *)getCoachDrivingSchool {
    return [[HHConstantsStore sharedInstance] getDrivingSchoolWithName:self.drivingSchool];
}

@end
