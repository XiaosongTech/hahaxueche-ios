//
//  HHCoachService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachService.h"
#import "HHTrainingField.h"

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
    query.limit = 20;
    NSMutableArray *fieldIds = [NSMutableArray array];
    if(fields) {
        for (HHTrainingField *field in fields) {
            [fieldIds addObject:field.objectId];
        }
        [query whereKey:kTrainingFieldIdKey containedIn:fieldIds];
    }
    
    switch (courseOption) {
        case CourseThree: {
            [query whereKey:@"course" equalTo:@"科目三"];
        }
            break;
        case CourseTwo:{
            [query whereKey:@"course" equalTo:@"科目二"];
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
            completion(objects, error);
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
    query.limit = 20;
    query.skip = skip;
    if (![searchQuery isEqualToString:@""]) {
        [query whereKey:@"fullName" containsString:searchQuery];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];

}

@end
