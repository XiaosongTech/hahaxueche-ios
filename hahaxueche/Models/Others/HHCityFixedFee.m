//
//  HHCityFixedFee.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCityFixedFee.h"

@implementation HHCityFixedFee

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"feeName": @"name",
             @"feeAmount": @"cost",
             };
}

@end
