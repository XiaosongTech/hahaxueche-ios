//
//  HHAdvisor.m
//  hahaxueche
//
//  Created by Zixiao Wang on 20/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAdvisor.h"

@implementation HHAdvisor

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"advisorId": @"id",
             @"name": @"name",
             @"avaURL": @"avatar",
             @"phoneNumber": @"phone",
             @"shortIntro": @"short_intro",
             @"longIntro":@"long_intro",
             };
}

@end
