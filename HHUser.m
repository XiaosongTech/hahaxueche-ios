//
//  HHUser.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUser.h"

@implementation HHUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cellPhone": @"cell_phone",
             @"userId": @"id",
             @"accessToken": @"session.access_token",
             @"student": @"student"
             };
}

+ (NSValueTransformer *)studentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HHStudent class]];
}

@end
