//
//  HHReferral.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferral.h"
#import "HHFormatUtility.h"

@implementation HHReferral

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"phone": @"phone",
             @"purchasedAt":@"purchased_at",
             };
}

+ (NSValueTransformer *)purchasedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}



@end
