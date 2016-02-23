//
//  HHStudentStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHStudent.h"
#import "HHUser.h"

@interface HHStudentStore : NSObject

@property (nonatomic, strong) HHStudent *currentStudent;

+ (instancetype)sharedInstance;

- (void)createGuestStudent;


@end
