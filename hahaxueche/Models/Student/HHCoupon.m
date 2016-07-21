//
//  HHCoupon.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoupon.h"

@implementation HHCoupon

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content": @"content",
             @"promoCode": @"promo_code",
             @"channelName": @"channel_name",
             @"status": @"status",
             };
}

@end
