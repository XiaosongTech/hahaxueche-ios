//
//  HHStudentStore.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHStudentStore.h"

@implementation HHStudentStore

+ (instancetype)sharedInstance {
    static HHStudentStore *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHStudentStore alloc] init];
    });
    
    return sharedInstance;
}

- (void)createGuestStudent {
    if (self.currentStudent) {
        return;
    }
    HHStudent *guestStudent = [[HHStudent alloc] init];
    guestStudent.cityId = @(0);
    self.currentStudent = guestStudent;
}


@end
