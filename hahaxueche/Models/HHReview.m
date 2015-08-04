//
//  HHReview.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReview.h"

@implementation HHReview

@dynamic rating;
@dynamic coachId;
@dynamic studentId;
@dynamic comment;

+ (NSString *)parseClassName {
    return @"Review";
}

@end
