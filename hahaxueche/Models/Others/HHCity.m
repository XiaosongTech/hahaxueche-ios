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
#import "HHCityZone.h"

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
             @"zoneObjects":@"zone_details",
             @"drivingSchools": @"driving_schools",
             };
}


+ (NSValueTransformer *)cityFixedFeesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityFixedFee class]];
}

+ (NSValueTransformer *)cityOtherFeesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityOtherFee class]];
}

+ (NSValueTransformer *)drivingSchoolsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHDrivingSchool class]];
}

+ (NSValueTransformer *)zoneObjectsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityZone class]];
}

- (NSArray *)getZoneNames {
    if (self.zoneNames.count > 0) {
        return self.zoneNames;
    } else {
        NSMutableArray *array = [NSMutableArray array];
        for (HHCityZone *zone in self.zoneObjects) {
            [array addObject:zone.zoneName];
        }
        return array;
    }
    
}

- (NSArray *)getZoneAreasWithName:(NSString *)zoneName {
    for (HHCityZone *zone in self.zoneObjects) {
        if ([zone.zoneName isEqualToString:zoneName]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:zone.areas];
            [array addObject:@"不限"];
            return array;
        }
    }
    return nil;
}


@end
