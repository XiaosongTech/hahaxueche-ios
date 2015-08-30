//
//  HHReviewService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHReview.h"
#import "HHCoach.h"

typedef void (^HHReviewsArrayCompletionBlock)(NSArray *objects, NSInteger totalCount, NSError *error);
typedef void (^HHReviewGenericCompletionBlock)(HHCoach *coach, NSError *error);

@interface HHReviewService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchReviewsForCoach:(NSString *)coachId skip:(NSInteger)skip completion:(HHReviewsArrayCompletionBlock)completion;

- (void)submitReview:(HHReview *)review completion:(HHReviewGenericCompletionBlock)completion;

@end
