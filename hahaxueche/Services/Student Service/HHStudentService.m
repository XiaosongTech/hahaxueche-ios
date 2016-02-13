//
//  HHStudentService.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHStudentService.h"
#import "APIPaths.h"
#import "HHStudentStore.h"
#import "HHAPIClient.h"

@implementation HHStudentService

+ (instancetype)sharedInstance {
    static HHStudentService *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHStudentService alloc] init];
    });
    
    return sharedInstance;
}

- (void)uploadStudentAvatarWithImage:(UIImage *)image completion:(HHStudentCompletion)completion {
    HHAPIClient *APIClient = [HHAPIClient apiClientWithPath:[NSString stringWithFormat:kAPIStudentAvatar, [HHStudentStore sharedInstance].currentStudent.studentId]];
    [APIClient uploadImage:image completion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            HHStudent *student = [MTLJSONAdapter modelOfClass:[HHStudent class] fromJSONDictionary:response error:nil];
            [HHStudentStore sharedInstance].currentStudent = student;
            if (completion) {
                completion(student, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
        
    } progress:nil];
}

@end
