//
//  HHBonus.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/30/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBonus.h"

@implementation HHBonus

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bonusName": @"name",
             @"bonusAmount": @"amount",
             };
}

@end
