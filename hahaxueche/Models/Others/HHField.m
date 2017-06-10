//
//  HHField.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHField.h"
#import "HHConstantsStore.h"

@implementation HHField

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fieldId": @"id",
             @"name": @"name",
             @"district": @"zone",
             @"address": @"address",
             @"longitude": @"lng",
             @"latitude":@"lat",
             @"cityId":@"city_id",
             @"displayAddress":@"display_address",
             @"coachCount":@"coach_count",
             @"consultPhone":@"consult_phone",
             @"img":@"image",
             @"drivingSchoolIds":@"driving_school_ids",
             @"zoneCenterLng":@"zone_center_lng",
             @"zoneCenterLat":@"zone_center_lat",
             @"businessAreas":@"business_areas",
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
