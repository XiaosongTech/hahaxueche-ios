//
//  HHBanks.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBank.h"

@implementation HHBank

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bankCode": @"code",
             @"bankName": @"name",
             @"isPopular": @"is_popular",
             };
}

@end
