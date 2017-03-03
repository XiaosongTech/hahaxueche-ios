//
//  HHIdentityCard.m
//  hahaxueche
//
//  Created by Zixiao Wang on 29/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHIdentityCard.h"

@implementation HHIdentityCard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address": @"address",
             @"num": @"num",
             @"gender": @"sex",
             @"name": @"name",
             };
}

- (BOOL)isVerified {
    return (self.name && self.num);
}

@end
