//
//  HHCoachFilters.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachFilters.h"

@implementation HHCoachFilters

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"price": @"price",
             @"distance": @"distance",
             @"onlyGoldenCoach": @"golden_coach_only",
             @"licenseType": @"license_type",
             };
}

- (id)copyWithZone:(NSZone *)zone {
    HHCoachFilters *newObject = [[HHCoachFilters alloc] init];
    newObject.price = self.price;
    newObject.distance = self.distance;
    newObject.onlyGoldenCoach = self.onlyGoldenCoach;
    newObject.licenseType = self.licenseType;
    newObject.onlyVIPCoach = self.onlyVIPCoach;
    return newObject;
}

@end
