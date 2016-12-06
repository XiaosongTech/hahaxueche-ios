//
//  HHTestScore.m
//  hahaxueche
//
//  Created by Zixiao Wang on 05/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestScore.h"
#import "HHFormatUtility.h"

@implementation HHTestScore

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course": @"course",
             @"score": @"score",
             @"createdAt": @"created_at",
             };
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}


@end
