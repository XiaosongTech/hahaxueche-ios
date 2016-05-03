//
//  HHWithdraw.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHWithdraw.h"
#import "HHFormatUtility.h"

@implementation HHWithdraw

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"withdrawId": @"id",
             @"amount": @"bonus_amount",
             @"redeemedDate":@"redeemed_at"
             };
}

+ (NSValueTransformer *)redeemedDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}


@end
