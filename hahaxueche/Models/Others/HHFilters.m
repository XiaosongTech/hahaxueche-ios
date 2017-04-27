//
//  HHCoachFilters.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFilters.h"

@implementation HHFilters

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"price": @"price",
             @"distance": @"distance",
             @"onlyGoldenCoach": @"golden_coach_only",
             @"licenseType": @"license_type",
             @"onlyVIPCoach": @"vip_only",
             };
}

- (id)copyWithZone:(NSZone *)zone {
    HHFilters *newObject = [[HHFilters alloc] init];
    newObject.price = self.price;
    newObject.distance = self.distance;
    newObject.onlyGoldenCoach = self.onlyGoldenCoach;
    newObject.licenseType = self.licenseType;
    newObject.onlyVIPCoach = self.onlyVIPCoach;
    return newObject;
}

@end
