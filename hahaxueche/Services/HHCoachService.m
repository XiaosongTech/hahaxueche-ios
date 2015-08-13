//
//  HHCoachService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachService.h"
#import "HHTrainingField.h"

#define kCountPerPage 20

@implementation HHCoachService

+ (HHCoachService *)sharedInstance {
    static HHCoachService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHCoachService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchCoachesWithTraningFields:(NSArray *)fields skip:(NSInteger)skip courseOption:(CourseOption)courseOption sortOption:(SortOption)sortOption completion:(HHCoachesArrayCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoach parseClassName]];
    query.skip = skip;
    query.limit = kCountPerPage;
    NSMutableArray *fieldIds = [NSMutableArray array];
    if(fields.count > 0) {
        for (HHTrainingField *field in fields) {
            [fieldIds addObject:field.objectId];
        }
        [query whereKey:kTrainingFieldIdKey containedIn:fieldIds];
    } 
    
    switch (courseOption) {
        case CourseThree: {
            [query whereKey:@"course" equalTo:NSLocalizedString(@"科目三",nil)];
        }
            break;
        case CourseTwo:{
            [query whereKey:@"course" equalTo:NSLocalizedString(@"科目二",nil)];
        }
            break;
        case CourseAllInOne: {
            [query whereKey:@"course" equalTo:NSLocalizedString(@"全程包干",nil)];
        }
            break;
            
        default:
            break;
    }
    
    switch (sortOption) {
        case SortOptionBestRating: {
            [query orderByDescending:@"averageRating"];
        }
            break;
            
        case SortOptionLowestPrice: {
           [query orderByAscending:@"price"];
        }
            break;
            
        case SortOptionMostPopular: {
            [query orderByDescending:@"currentStudentAmount"];
        }
            break;
        case SortOptionSmartSort: {
            
        }
            break;
            
        default:
            break;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, [query countObjects], error);
        }
    }];
}



- (void)fetchCoachWithId:(NSString *)coachId completion:(HHCoachCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoach parseClassName]];
    [query whereKey:kCoachIdKey equalTo:coachId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (completion) {
            completion((HHCoach *)object, error);
        }
    }];
}


- (void)fetchCoachesWithQuery:(NSString *)searchQuery skip:(NSInteger)skip completion:(HHCoachesArrayCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoach parseClassName]];
    query.limit = kCountPerPage;
    query.skip = skip;
    if (![searchQuery isEqualToString:@""]) {
        [query whereKey:@"fullName" containsString:searchQuery];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, [query countObjects], error);
        }
    }];

}

- (void)fetchReviewsForCoach:(NSString *)coachId skip:(NSInteger)skip completion:(HHCoachesArrayCompletionBlock)completion {
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

@end