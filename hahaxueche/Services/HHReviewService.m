//
//  HHReviewService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReviewService.h"

#define kCountPerPage 20

@implementation HHReviewService


+ (HHReviewService *)sharedInstance {
    static HHReviewService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHReviewService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchReviewsForCoach:(NSString *)coachId skip:(NSInteger)skip completion:(HHReviewsArrayCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHReview parseClassName]];
    query.limit = kCountPerPage;
    query.skip = skip;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"coachId" equalTo:coachId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, [query countObjects], error);
        }
    }];
}

- (void)submitReview:(HHReview *)review completion:(HHReviewGenericCompletionBlock)completion {
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            return ;
        }
        if (succeeded) {
            AVQuery *query = [AVQuery queryWithClassName:[HHCoach parseClassName]];
            [query whereKey:@"coachId" equalTo:review.coachId];
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (error) {
                    if (completion) {
                        completion(nil, error);
                    }
                    return ;
                }
                HHCoach *coach = (HHCoach *)object;
                CGFloat newAverageRating = (([coach.averageRating floatValue] * [coach.totalReviewAmount integerValue]) + [review.rating floatValue])/([coach.totalReviewAmount integerValue] + 1);
                coach.averageRating = [NSNumber numberWithFloat:newAverageRating];
                coach.totalReviewAmount = [NSNumber numberWithInteger:[coach.totalReviewAmount integerValue] + 1];
                [coach saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        if (completion) {
                            completion(nil, error);
                        }
                        [review delete];
                        return ;
                    }
                    if (completion) {
                        completion(coach, error);
                    }

                }];
            }];
        }
    }];
}

@end
