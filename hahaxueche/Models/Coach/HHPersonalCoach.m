//
//  HHPersonalCoach.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPersonalCoach.h"
#import "HHPersonalCoachPrice.h"

@implementation HHPersonalCoach

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"coachId": @"id",
             @"avatarUrl": @"avatar",
             @"cityId": @"city_id",
             @"experienceYear":@"experiences",
             @"intro":@"description",
             @"phoneNumber":@"phone",
             @"images":@"images",
             @"liked":@"liked",
             @"likeCount":@"like_count",
             @"prices":@"prices",
             };
}

+ (NSValueTransformer *)pricesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPersonalCoachPrice class]];
}


- (NSString *)getCoachDes {
    NSString *string = nil;
    for (NSString *stringPart in self.intro) {
        [string stringByAppendingString:[NSString stringWithFormat:@"\n%@", stringPart]];
    }
    return string;
}

@end
