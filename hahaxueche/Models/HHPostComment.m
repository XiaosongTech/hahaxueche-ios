//
//  HHPostComment.m
//  hahaxueche
//
//  Created by Zixiao Wang on 02/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPostComment.h"

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

@end
