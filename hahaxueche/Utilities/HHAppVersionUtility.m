//
//  HHAppVersionUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 13/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAppVersionUtility.h"

@implementation HHAppVersionUtility

+ (HHAppVersionUtility *)sharedManager {
    static HHAppVersionUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHAppVersionUtility alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[Harpy sharedInstance] setAppID:@"1011236187"];
        [[Harpy sharedInstance] setAppName:@"哈哈学车"];
        [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
        [[Harpy sharedInstance] setDebugEnabled:YES];
        [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
        [[Harpy sharedInstance] setCountryCode:@"CN"];
        
    }
    return self;
}


- (void)checkVersionInVC:(UIViewController *)inVC {
    [[Harpy sharedInstance] setPresentingViewController:inVC];
    [[Harpy sharedInstance] checkVersion];
}

@end
