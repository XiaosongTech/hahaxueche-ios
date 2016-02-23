//
//  HHCoaches.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoaches.h"
#import "HHCoach.h"

@implementation HHCoaches

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"coaches":@"data"
             };
}

+ (NSValueTransformer *)coachesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCoach class]];
}

@end
