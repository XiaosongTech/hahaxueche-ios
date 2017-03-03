//
//  HHInsuranceOrder.m
//  hahaxueche
//
//  Created by Zixiao Wang on 01/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHInsuranceOrder.h"
#import "HHFormatUtility.h"

@implementation HHInsuranceOrder

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"policyNum": @"policy_no",
             @"paidAt":@"paid_at",
             @"paidAmount":@"total_amount",
             @"policyStartTime":@"policy_start_time",
            };
}

+ (NSValueTransformer *)paidAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)policyStartTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (BOOL)isPurchased {
    return self.paidAt;
}

- (BOOL)isInsured {
    return self.policyNum;
}
@end
