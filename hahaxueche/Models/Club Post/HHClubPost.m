//
//  HHClubPost.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPost.h"
#import "HHPostComment.h"
#import "HHFormatUtility.h"
#import "HHConstantsStore.h"
#import "HHPostCategory.h"

@implementation HHClubPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postId":@"id",
             @"title":@"title",
             @"abstract":@"intro",
             @"coverImg":@"cover_image",
             @"category":@"category",
             @"createdAt":@"created_at",
             @"viewCount":@"view_count",
             @"likeCount":@"like_count",
             @"comments":@"comments",
             @"liked":@"liked",
             };
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPostComment class]];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[HHFormatUtility backendDateFormatter] stringFromDate:date];
    }];
}

- (NSString *)getCategoryName {
    NSArray *categories = [HHConstantsStore sharedInstance].constants.postCategory;
    for (HHPostCategory *category in categories) {
        if ([self.category isEqual:category.type]) {
            return category.name;
        }
    }
    return nil;
}

- (NSString *)getPostUrl {
    
#ifdef DEBUG
    return [NSString stringWithFormat:@"https://staging-m.hahaxueche.com/wenzhang/%@?view=raw", self.postId];
#else
    return [NSString stringWithFormat:@"https://m.hahaxueche.com/wenzhang/%@?view=raw", self.postId];
#endif
    
}

- (NSString *)getShareUrl {
    
#ifdef DEBUG
    return [NSString stringWithFormat:@"https://staging-m.hahaxueche.com/wenzhang/%@", self.postId];
#else
    return [NSString stringWithFormat:@"https://m.hahaxueche.com/wenzhang/%@", self.postId];
#endif
}

@end
