//
//  HHAppDelegate.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/4/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAppDelegate.h"
#import <Instabug/Instabug.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HHEventTrackingManager.h"
#import "SDWebImage/SDWebImageManager.h"
#import <SSKeychain/SSKeychain.h>
#import "HHIntroViewController.h"
#import "UIColor+HHColor.h"
#import "HHConstantsStore.h"
#import "HHKeychainStore.h"
#import "HHUserAuthService.h"
#import "HHStudentStore.h"
#import "HHRootViewController.h"
#import "HHAccountSetupViewController.h"

@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[HHUserAuthService sharedInstance] getSavedUser] && [HHKeychainStore getSavedAccessToken]) {
        HHStudent *student = [[[HHUserAuthService sharedInstance] getSavedUser] student];
        if (!student.name || !student.cityId) {
            HHAccountSetupViewController *accountVC = [[HHAccountSetupViewController alloc] initWithStudentId:student.studentId];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:accountVC];
            [self.window setRootViewController:navVC];
        } else {
            // Get the saved student object, we lead user to rootVC
            [HHStudentStore sharedInstance].currentStudent = [[[HHUserAuthService sharedInstance] getSavedUser] student];
            HHRootViewController *rootVC = [[HHRootViewController alloc] init];
            [self.window setRootViewController:rootVC];
        }
        
        
    } else {
        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
        [self.window setRootViewController:navVC];
       
    }
    
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    
    [self setupAllThirdPartyServices];
    [self setAppearance];
    
    //pre-fetch constants
    [[HHConstantsStore sharedInstance] getConstantsWithCompletion:nil];
    return YES;
}


- (void)setAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor HHOrange]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor HHOrange]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
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
    
    //SDWebImage
    [SDWebImageManager sharedManager].imageCache.maxCacheSize = 20000000;
    [[[SDWebImageManager sharedManager] imageDownloader] setMaxConcurrentDownloads:10];
    [[[SDWebImageManager sharedManager] imageDownloader] setExecutionOrder:SDWebImageDownloaderLIFOExecutionOrder];
}

@end
