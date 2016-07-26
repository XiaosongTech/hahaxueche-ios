//
//  HHActivity.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHEvent.h"
#import "HHFormatUtility.h"

@implementation HHEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"title",
             @"endDate": @"end_date",
             @"type": @"event_type",
             @"icon": @"icon",
             @"webURL": @"url",
             };
}


+ (NSValueTransformer *)endDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility fullDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility fullDateFormatter] stringFromDate:date];
    }];
}

@end
