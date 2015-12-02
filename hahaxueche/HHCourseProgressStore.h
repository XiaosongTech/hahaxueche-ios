//
//  HHCourseProgressStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 12/1/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HHCourseProgressCompletionBlock)(NSArray *courseProgressArray, NSError *error);

@interface HHCourseProgressStore : NSObject

+ (instancetype)sharedInstance;
- (void)getCourseProgressArrayWithCompletion:(HHCourseProgressCompletionBlock)completion;
- (void)filterCourseProgressArrayWithCournseName:(NSString *)courseName Completion:(HHCourseProgressCompletionBlock)completion;


@end
