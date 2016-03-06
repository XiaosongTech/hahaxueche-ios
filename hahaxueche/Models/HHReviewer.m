//
//  HHReviewer.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReviewer.h"

@implementation HHReviewer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"reviewerId":@"id",
             @"avatarUrl":@"avatar_url",
             @"reviewerName":@"name",
             @"userType":@"user_type"
             };
}

@end
