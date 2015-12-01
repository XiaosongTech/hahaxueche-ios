//
//  HHCourseProgressStore.m
//  hahaxueche
//
//  Created by Zixiao Wang on 12/1/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHCourseProgressStore.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HHCourseProgress.h"

@interface HHCourseProgressStore ()

@property (nonatomic, strong) NSArray *courseProgressArray;

@end

@implementation HHCourseProgressStore

+ (HHCourseProgressStore *)sharedInstance {
    static HHCourseProgressStore *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHCourseProgressStore alloc] init];
    });
    
    return sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self fetchCourseProgressWithCompletion:nil];
    }
    return self;
}

- (void)fetchCourseProgressWithCompletion:(HHCourseProgressCompletionBlock)completion {
    AVQuery *query = [AVQuery queryWithClassName:[HHCourseProgress parseClassName]];
    [query orderByAscending:@"progressNumber"];
    query.limit = 100;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.courseProgressArray = objects;
        }
        if (completion) {
            completion (objects, error);
        }
        
    }];
}

- (void)getCourseProgressArrayWithCompletion:(HHCourseProgressCompletionBlock)completion {
    if ([self.courseProgressArray count]) {
        if (completion) {
            completion(self.courseProgressArray, nil);
        }
    } else {
        [self fetchCourseProgressWithCompletion:completion];
    }
}

- (void)filterCourseProgressArrayWithCournseName:(NSString *)courseName Completion:(HHCourseProgressCompletionBlock)completion {
    __block NSArray *array = nil;
    __weak HHCourseProgressStore *weakSelf = self;
    [weakSelf getCourseProgressArrayWithCompletion:^(NSArray *courseProgressArray, NSError *error) {
        if (!error) {
            NSMutableArray *filteredArray = [NSMutableArray array];
            for (HHCourseProgress *courseProgress in courseProgressArray) {
                if ([courseProgress.courseName isEqualToString:courseName]) {
                    [filteredArray addObject:courseProgress];
                }
            }
            array =  filteredArray;
        }
        
        if (completion) {
            completion(array, error);
        }
    }];

}




@end
