//
//  HHVoucher.m
//  hahaxueche
//
//  Created by Zixiao Wang on 10/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHVoucher.h"
#import "HHFormatUtility.h"

@implementation HHVoucher

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"voucherId": @"id",
             @"title": @"title",
             @"des": @"description",
             @"expiredAt": @"expired_at",
             @"code": @"code",
             @"amount": @"amount",
             @"status": @"status",
             };
}

+ (NSValueTransformer *)expiredAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (NSString *)getStatusString {
    if ([self.status integerValue] == 0) {
        return @"未使用";
    } else if ([self.status integerValue] == 1) {
        return @"已使用";
    } else {
        return @"已过期";
    }
    
}



@end
