//
//  HHCoachSchedules.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachSchedules.h"
#import "HHCoachSchedule.h"

@implementation HHCoachSchedules

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"schedules":@"data"
             };
}

+ (NSValueTransformer *)schedulesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCoachSchedule class]];
}


@end
