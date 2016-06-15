//
//  HHReferrals.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferrals.h"

@implementation HHReferrals

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"referrals":@"data"
             };
}

+ (NSValueTransformer *)referralsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHReferral class]];
}


@end
