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
             @"status": @"status",
             @"amount": @"amount",
             @"withdrawedAt":@"withdrawed_at"
             };
}

+ (NSValueTransformer *)withdrawedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (NSString *)getStatusString {
    if ([self.status isEqual:@(0)]) {
        return @"处理中";
    } else if ([self.status isEqual:@(1)]) {
        return @"成功";
    } else {
        return @"失败";
    }
}

@end
