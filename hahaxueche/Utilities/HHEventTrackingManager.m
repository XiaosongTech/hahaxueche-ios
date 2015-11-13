//
//  HHEventTrackingManager.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHEventTrackingManager.h"
#import <MobClick.h>

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
        [MobClick startWithAppkey:@"5645831de0f55a1d0300031d" reportPolicy:BATCH channelId:@"iOS"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
#endif
       
    }
    return self;
}

- (void)studentSignedUpOrLoggedIn:(NSString *)studentId {
    [MobClick profileSignInWithPUID:studentId];
}

- (void)studentLoggedOff {
    [MobClick profileSignOff];
}


@end
