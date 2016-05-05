//
//  HHBonusSummary.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBonusSummary.h"

@implementation HHBonusSummary

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"pendingAmount": @"pending_add_to_account",
             @"availableAmount": @"available_to_redeem",
             @"redeemedAmount":@"redeemed",
             };
}

@end
