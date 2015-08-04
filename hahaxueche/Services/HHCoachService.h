//
//  HHCoachService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHCoach.h"
#import "HHCoachListViewController.h"
#import "HHReview.h"

typedef void (^HHCoachesArrayCompletionBlock)(NSArray *objects, NSInteger totalCount, NSError *error);
typedef void (^HHCoachCompletionBlock)(HHCoach *coach, NSError *error);

@interface HHCoachService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchCoachesWithTraningFields:(NSArray *)fields skip:(NSInteger)skip courseOption:(CourseOption)courseOption sortOption:(SortOption)sortOption completion:(HHCoachesArrayCompletionBlock)completion;

- (void)fetchCoachWithId:(NSString *)coachId completion:(HHCoachCompletionBlock)completion;

- (void)fetchCoachesWithQuery:(NSString *)searchQuery skip:(NSInteger)startIndex completion:(HHCoachesArrayCompletionBlock)completion;

- (void)fetchReviewsForCoach:(NSString *)coachId skip:(NSInteger)skip completion:(HHCoachesArrayCompletionBlock)completion;

@end
