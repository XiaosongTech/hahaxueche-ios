//
//  HHAppDelegate.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/4/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAppDelegate.h"
#import "Appirater.h"
#import <Instabug/Instabug.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HHEventTrackingManager.h"


@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:nil];
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    
    
    [self setupAllThirdPartyServices];
    [self setAppearance];
    return YES;
}


- (void)setAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setupAllThirdPartyServices {
    
    // Instabug
#ifdef DEBUG
    [Instabug startWithToken:@"84e5be6250eaf585a69368e09fe6dca3" captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
    [Instabug setIsTrackingCrashes:NO];
#else
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSString *receiptURLString = [receiptURL path];
    BOOL isRunningTestFlightBeta =  ([receiptURLString rangeOfString:@"sandboxReceipt"].location != NSNotFound);
    if (isRunningTestFlightBeta) {
        [Instabug startWithToken:@"84e5be6250eaf585a69368e09fe6dca3" captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
        [Instabug setIsTrackingCrashes:NO];
    }
    
#endif

    //Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    
    //Umeng
    [HHEventTrackingManager sharedManager];
}

@end
