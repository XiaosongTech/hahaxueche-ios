//
//  HHField.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHField.h"

@implementation HHField

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fieldId": @"id",
             @"name": @"name",
             @"district": @"section",
             @"address": @"street",
             @"longitude": @"lng",
             @"latitude":@"lat",
             @"cityId":@"city_id",
             };
}



+ (NSValueTransformer*)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"longitude"] || [key isEqualToString:@"latitude"]) {
        
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [formatter numberFromString:value];
            return number;
        }];
    } else {
        return nil;
    }
}

@end
