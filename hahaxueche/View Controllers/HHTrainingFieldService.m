//
//  HHTrainingFieldService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTrainingFieldService.h"

@implementation HHTrainingFieldService


+ (HHTrainingFieldService *)sharedInstance {
    static HHTrainingFieldService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHTrainingFieldService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchTrainingFieldWithId:(NSString *)fieldId completion:(HHFieldCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHTrainingField parseClassName]];
    [query getObjectInBackgroundWithId:fieldId block:^(AVObject *object, NSError *error) {
        if (completion) {
            completion((HHTrainingField *)object, error);
        }
    }];
}

- (void)fetchTrainingFieldsForCity:(NSString *)city completion:(HHFieldArrayCompletionBlock)competion {
    AVQuery *query = [AVQuery queryWithClassName:[HHTrainingField parseClassName]];
    query.limit = 100;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.supportedFields = objects;
            self.selectedFields = [NSMutableArray arrayWithArray:self.supportedFields];;
        }
        if (competion) {
            competion(objects, error);
        }
    }];
}

@end
