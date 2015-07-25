//
//  HHCoachService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachService.h"

@implementation HHCoachService

+ (HHCoachService *)sharedInstance {
    static HHCoachService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHCoachService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchCoachesWithTraningFieldIds:(NSArray *)fieldIds startIndex:(NSInteger)startIndex completion:(HHCoachesArrayCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCoach parseClassName]];
    query.skip = startIndex;
    query.limit = 20;
    if(fieldIds) {
        for (NSString *fieldId in fieldIds) {
            [query whereKey:kTrainingFieldIdKey equalTo:fieldId];
        }
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

- (void)fetchTrainingFieldWithId:(NSString *)fieldId completion:(HHCoachFieldCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHTrainingField parseClassName]];
    [query getObjectInBackgroundWithId:fieldId block:^(AVObject *object, NSError *error) {
        if (completion) {
            completion((HHTrainingField *)object, error);
        }
    }];
}


@end
