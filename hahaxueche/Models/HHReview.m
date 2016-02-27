//
//  HHReview.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReview.h"

@implementation HHReview

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"reviewId":@"id",
             @"reviewer": @"reviewer",
             @"comment": @"comment",
             @"rating": @"rating",
             @"date": @"updated_at",
            };
}

+ (NSValueTransformer *)reviewerJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HHStudent class]];
}


@end
