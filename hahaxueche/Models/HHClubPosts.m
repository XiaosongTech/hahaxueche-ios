//
//  HHClubPosts.m
//  hahaxueche
//
//  Created by Zixiao Wang on 02/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPosts.h"
#import "HHClubPost.h"

@implementation HHClubPosts

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"posts":@"data"
             };
}

+ (NSValueTransformer *)postsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHClubPost class]];
}

@end
