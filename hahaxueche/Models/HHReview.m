//
//  HHReview.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReview.h"
#import "HHFormatUtility.h"

@implementation HHReview

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"reviewId":@"id",
             @"reviewer": @"reviewer",
             @"comment": @"comment",
             @"rating": @"rating",
             @"updatedAt": @"updated_at",
            };
}

+ (NSValueTransformer *)reviewerJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HHReviewer class]];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

@end
