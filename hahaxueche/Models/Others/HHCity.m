//
//  HHCity.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCity.h"
#import "HHCityFixedFee.h"
#import "HHBonus.h"

@implementation HHCity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cityId": @"id",
             @"cityName": @"name",
             @"priceRanges":@"filters.prices",
             @"distanceRanges":@"filters.radius",
             @"zipCode":@"zip_code",
             @"cityFixedFees":@"fixed_cost_itemizer",
             @"referrerBonus":@"referer_bonus",
             @"refereeBonus":@"referee_bonus",
             @"referalBanner":@"referral_banner",
             };
}


+ (NSValueTransformer *)cityFixedFeesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityFixedFee class]];
}


@end
