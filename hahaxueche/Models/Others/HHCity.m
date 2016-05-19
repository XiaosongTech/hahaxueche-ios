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
             @"bonus":@"referal_bonus",
             @"referalBanner":@"referral_banner",
             };
}


+ (NSValueTransformer *)cityFixedFeesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCityFixedFee class]];
}

+ (NSValueTransformer *)bonusJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHBonus class]];
}

- (NSNumber *)getRefereeBonus {
    for (HHBonus *bonus in self.bonus) {
        if ([bonus.bonusName isEqualToString:@"referee_bonus"]) {
            return bonus.bonusAmount;
        }
    }
    return nil;
}

- (NSNumber *)getRefererBonus {
    for (HHBonus *bonus in self.bonus) {
        if ([bonus.bonusName isEqualToString:@"referer_bonus"]) {
            return bonus.bonusAmount;
        }
    }
    return nil;
}

- (NSNumber *)getTotalBonus {
    return @([[self getRefererBonus] floatValue] + [self.getRefereeBonus floatValue]);
}


@end
