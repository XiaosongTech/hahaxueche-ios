//
//  HHNetworkUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/28/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHNetworkUtility.h"
#import "AFNetworking.h"
#import "HHToastManager.h"

@implementation HHNetworkUtility

+ (HHNetworkUtility *)sharedManager {
    static HHNetworkUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHNetworkUtility alloc] init];
    });
    
    return manager;
}


- (void)monitorNetwork {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                [[HHToastManager sharedManager] showErrorToastWithText:@"网络异常, 请检查网络设置!"];
            } break;
            default:
                break;
        }
        
    }];
}

@end
