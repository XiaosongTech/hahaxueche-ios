//
//  HHDrivingSchools.m
//  hahaxueche
//
//  Created by Zixiao Wang on 02/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHDrivingSchools.h"
#import "HHDrivingSchool.h"

@implementation HHDrivingSchools

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"schools":@"data"
             };
}

+ (NSValueTransformer *)schoolsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHDrivingSchool class]];
}

@end
