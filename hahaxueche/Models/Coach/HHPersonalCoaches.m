//
//  HHPersonalCoaches.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPersonalCoaches.h"
#import "HHPersonalCoach.h"

@implementation HHPersonalCoaches

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"coaches":@"data"
             };
}

+ (NSValueTransformer *)coachesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPersonalCoach class]];
}


@end
