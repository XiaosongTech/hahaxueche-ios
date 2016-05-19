//
//  HHStudent.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHStudent.h"

@implementation HHStudent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"studentId": @"id",
             @"userId": @"user_id",
             @"cellPhone": @"cell_phone",
             @"name": @"name",
             @"cityId": @"city_id",
             @"avatarURL": @"avatar",
             @"purchasedServiceArray":@"purchased_services",
             @"currentCoachId":@"current_coach_id",
             @"currentCourse":@"current_course",
             @"bonusBalance":@"bonus_balance",
             @"byReferal":@"by_referal",
             };
}

+ (NSValueTransformer *)purchasedServiceArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPurchasedService class]];
}

- (NSString *)getCourseName {
    switch ([self.currentCourse integerValue]) {
        case 0: {
            return @"科目一";
        }
        case 1: {
            return @"科目二";
        }
        case 2: {
            return @"科目三";
        }
        case 3: {
            return @"科目四";
        }
        default: {
            return @"已拿证";
        }
            
    }
}

@end
