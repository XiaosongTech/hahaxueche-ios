//
//  HHConstants.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHConstants.h"
#import "HHCity.h"
#import "HHField.h"

@implementation HHConstants

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cities": @"cities",
             @"fields": @"fields",
             };
}

+ (NSValueTransformer *)citiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCity class]];
}

+ (NSValueTransformer *)fieldsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHField class]];
}


@end
