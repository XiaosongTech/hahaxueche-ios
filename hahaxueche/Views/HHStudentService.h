//
//  HHStudentService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHStudent.h"

typedef void (^HHStudentsCompletionBlock)(NSArray *objects, NSError *error);

@interface HHStudentService : NSObject

+ (instancetype)sharedInstance;

- (void)fetchStudentsForScheduleWithIds:(NSArray *)studentIds completion:(HHStudentsCompletionBlock)completion;


@end
