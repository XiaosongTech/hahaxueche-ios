//
//  HHPostComment.m
//  hahaxueche
//
//  Created by Zixiao Wang on 03/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPostComment.h"
#import "HHFormatUtility.h"

@implementation HHPostComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"studentId":@"student_id",
             @"studentName":@"student_name",
             @"content":@"content",
             @"createdAt":@"created_at",
             @"avatar":@"avatar_url",
             };
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (NSString *)getShareUrl {
    return @"https://staging-api.hahaxueche.net/share/article_contents/fd287651-7ebe-4193-8945-242bf9d1ea27";
}

- (NSString *)getPostUrl {
    return @"https://staging-m.hahaxueche.com/articles/ea17d34e-968d-4dcd-bf3d-1d49628fd6a8";
}

@end
