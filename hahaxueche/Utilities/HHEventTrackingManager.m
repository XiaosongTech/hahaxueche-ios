//
//  HHEventTrackingManager.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHEventTrackingManager.h"
#import "UMMobClick/MobClick.h"

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
        UMConfigInstance.appKey = @"5645831de0f55a1d0300031d";
        UMConfigInstance.channelId = @"App Store";
        [MobClick setLogEnabled:YES];
        
    #else
        UMConfigInstance.appKey = @"564a6b5ee0f55a2646005412";
        UMConfigInstance.channelId = @"App Store";
        [MobClick setLogEnabled:NO];

    #endif
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
    }
    
    return self;
}



@end
