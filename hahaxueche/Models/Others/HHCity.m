//
//  HHCity.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCity.h"

@implementation HHCity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cityId": @"id",
             @"cityName": @"name",
             };
}

@end
