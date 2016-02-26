//
//  HHReviews.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReviews.h"
#import "HHReview.h"

@implementation HHReviews

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"reviews":@"data"
             };
}

+ (NSValueTransformer *)reviewsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHReview class]];
}

@end
