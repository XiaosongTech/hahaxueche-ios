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
#import "HHLaunchImageViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "HHSocialMediaShareUtility.h"
#import <Pingpp/Pingpp.h>
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHEventTrackingManager.h"

static NSString *const kMapServiceKey = @"b1f6d0a0e2470c6a1145bf90e1cdebe4";

@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HHLaunchImageViewController *launchVC = [[HHLaunchImageViewController alloc] init];
    [self.window setRootViewController:launchVC];
    
    [[HHConstantsStore sharedInstance] getConstantsWithCompletion:^(HHConstants *constants) {
        if (constants) {
            if ([[HHUserAuthService sharedInstance] getSavedUser] && [HHKeychainStore getSavedAccessToken]) {
                HHStudent *savedStudent = [[[HHUserAuthService sharedInstance] getSavedUser] student];
                [[HHUserAuthService sharedInstance] isTokenValid:savedStudent.cellPhone completion:^(BOOL valid) {
                    if (valid) {
                        [[HHStudentService sharedInstance] fetchStudentWithId:savedStudent.studentId completion:^(HHStudent *student, NSError *error) {
                            if (!error) {
                                [HHStudentStore sharedInstance].currentStudent = student;
                                if (!student.name || !student.cityId) {
                                    // Student created, but not set up yet
                                    HHAccountSetupViewController *accountVC = [[HHAccountSetupViewController alloc] initWithStudentId:student.studentId];
                                    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:accountVC];
                                    [self.window setRootViewController:navVC];
                                } else {
                                    // Get the saved student object, we lead user to rootVC
                                    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
                                    [self.window setRootViewController:rootVC];
                                }
                            } else {
                                HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
                                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
                                [self.window setRootViewController:navVC];
                            }
                            
                        }];
                    } else {
                        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
                        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
                        [self.window setRootViewController:navVC];

                    }
                }];
                
            } else {
                HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
                [self.window setRootViewController:navVC];
                
            }
        } else {
            HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
            [self.window setRootViewController:navVC];
        }
       
    }];
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    [self setupAllThirdPartyServices];
    [self setAppearance];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}


- (void)setAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor HHOrange]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor HHOrange]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

- (void)setupAllThirdPartyServices {
    
    // Instabug
#ifdef DEBUG
    [Instabug startWithToken:@"84e5be6250eaf585a69368e09fe6dca3" captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
    [Instabug setIsTrackingCrashes:NO];
    [Pingpp setDebugMode:YES];
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
    
    [MAMapServices sharedServices].apiKey = kMapServiceKey;
    
    [HHSocialMediaShareUtility configure];
    
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    
    [HHEventTrackingManager sharedManager];
}

@end
