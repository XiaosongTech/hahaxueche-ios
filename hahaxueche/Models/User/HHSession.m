//
//  HHSession.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSession.h"

@implementation HHSession

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"accessToken": @"access_token",
             @"sessionId": @"id",
             };
}


@end
