//
//  HHStudentService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStudentService.h"

@implementation HHStudentService

+ (HHStudentService *)sharedInstance {
    static HHStudentService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHStudentService alloc] init];
    });
    
    return sharedInstance;
}

- (void)fetchStudentsForScheduleWithIds:(NSArray *)studentIds completion:(HHStudentsCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHStudent parseClassName]];
    [query whereKey:@"studentId" containedIn:studentIds];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];
}

-(void)fetchStudentsWithId:(NSString *)studentId completion:(HHStudentCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHStudent parseClassName]];
    [query whereKey:@"studentId" equalTo:studentId];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (completion) {
            completion(object, error);
        }
    }];
}

@end
