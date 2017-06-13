//
//  HHCityZone.m
//  hahaxueche
//
//  Created by Zixiao Wang on 08/06/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHCityZone.h"

@implementation HHCityZone

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"zoneName": @"zone",
             @"areas": @"business_areas",
             
             };
}

@end
