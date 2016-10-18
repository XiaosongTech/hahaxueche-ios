//
//  HHPersonalCoachFilters.m
//  hahaxueche
//
//  Created by Zixiao Wang on 18/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPersonalCoachFilters.h"

@implementation HHPersonalCoachFilters

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"price": @"price",
             @"licenseType": @"license_type",
            };
}

- (id)copyWithZone:(NSZone *)zone {
    HHPersonalCoachFilters *newObject = [[HHPersonalCoachFilters alloc] init];
    newObject.price = self.price;
    newObject.licenseType = self.licenseType;
    return newObject;
}


@end
