//
//  HHEventTrackingManager.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHEventTrackingManager.h"

@implementation HHEventTrackingManager

+ (HHEventTrackingManager *)sharedManager {
    static HHEventTrackingManager *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHEventTrackingManager alloc] init];
    });
    
    return manager;
}


- (id)init {
    self = [super init];
    if (self) {
        
#ifdef DEBUG
        
        
        
#else
        
#endif
    }
    
    return self;
}



@end
