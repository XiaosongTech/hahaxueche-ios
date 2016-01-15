//
//  HHCoachFilters.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachFilters.h"

@implementation HHCoachFilters

+ (instancetype)sharedInstance {
    static HHCoachFilters *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        sharedInstance = [[HHCoachFilters alloc] init];
    });
    
    return sharedInstance;
}

@end
