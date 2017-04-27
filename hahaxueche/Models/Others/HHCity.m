//
//  HHCity.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCity.h"
#import "HHCityFixedFee.h"
#import "HHCityOtherFee.h"
#import "HHBonus.h"
#import "HHDrivingSchool.h"

@implementation HHCity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cityId": @"id",
             @"cityName": @"name",
             @"priceRanges":@"filters.prices",
             @"distanceRanges":@"filters.radius",
             @"zipCode":@"zip_code",
             @"cityFixedFees":@"fixed_cost_itemizer",
             @"cityOtherFees":@"other_fee",
             @"referrerBonus":@"referer_bonus",
             @"refereeBonus":@"referee_bonus",
             @"referalBanner":@"referral_banner",
             @"zones":@"zones",
             };
}


+ (NSValueTransformer *)cityFixedFeesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityFixedFee class]];
}

+ (NSValueTransformer *)cityOtherFeesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityOtherFee class]];
}



@end
