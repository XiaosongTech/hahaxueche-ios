//
//  HHNotification.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHNotification.h"

@implementation HHNotification

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"text": @"text",
             @"avaURL": @"avatar_url",
             @"highlights": @"highlights",
             @"name": @"name",
             };
}

@end
