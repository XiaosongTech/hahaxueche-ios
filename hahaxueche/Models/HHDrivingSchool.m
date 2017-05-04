//
//  HHDrivingSchool.m
//  hahaxueche
//
//  Created by Zixiao Wang on 13/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHDrivingSchool.h"

@implementation HHDrivingSchool

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"schoolId": @"id",
             @"schoolName": @"name",
             @"coachCount": @"coach_count",
             @"fieldCount": @"field_count",
             @"rating": @"rating",
             @"reviewCount": @"review_count",
             @"passRate":@"pass_rate",
             @"images":@"images",
             @"lowestPrice":@"lowest_price",
             @"consultCount":@"consult_count",
             @"avatar":@"avatar",
             @"consultPhone":@"consult_phone",
             @"zones":@"zones",
             @"distance":@"distance",
             @"nearestFieldZone":@"closest_zone"
             };
}

@end
