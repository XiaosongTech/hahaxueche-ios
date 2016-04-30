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
#import <Appirater.h>
#import "Branch.h"
#import "HHCoachDetailViewController.h"
#import "HHLoadingViewUtility.h"

static NSString *const kMapServiceKey = @"b1f6d0a0e2470c6a1145bf90e1cdebe4";

@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HHLaunchImageViewController *launchVC = [[HHLaunchImageViewController alloc] init];
    [self.window setRootViewController:launchVC];
    
    
    
    HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
    __block UINavigationController *introNavVC = [[UINavigationController alloc] initWithRootViewController:introVC];
    
    __block UIViewController *finalRootVC = introNavVC;
    
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
                                    finalRootVC = navVC;
                                } else {
                                    // Get the saved student object, we lead user to rootVC
                                    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
                                    finalRootVC = rootVC;
                                }
                            } else {
                                finalRootVC = introNavVC;
                            }
                            
                        }];
                    } else {
                        finalRootVC = introNavVC;
                    }
                }];
                
            } else {
                finalRootVC = introNavVC;
                
            }
        } else {
            finalRootVC = introNavVC;
        }
       
    }];
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    [self setupAllThirdPartyServices];
    [self setAppearance];
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        self.window.rootViewController = finalRootVC;
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            //not Branch link
            if (![params[@"+clicked_branch_link"] boolValue]) {
                return ;
            }
            //handle Branch link
            NSString *coachId = params[@"coachId"];
            if (coachId) {
                HHCoachDetailViewController *coachVC = [[HHCoachDetailViewController alloc] initWithCoachId:coachId];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:coachVC];
                [[HHAppDelegate topMostController] presentViewController:navVC animated:YES completion:nil];
            }
            
            NSString *refererId = params[@"refererId"];
            if (refererId) {
                [HHConstantsStore sharedInstance].refererId = refererId;;
            }
        }
    }];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    BOOL canHandlePingppURL = [Pingpp handleOpenURL:url withCompletion:nil];
    if (canHandlePingppURL) {
        return YES;
    }
    
    BOOL canHandleBranchURL = [[Branch getInstance] handleDeepLink:url];
    if (canHandleBranchURL) {
        if (![[HHAppDelegate topMostController] isKindOfClass:[HHLaunchImageViewController class]]) {
            [[HHLoadingViewUtility sharedInstance] showLoadingView];
        }
        return YES;
    }
    
    BOOL canHandleOpenShareURL = [OpenShare handleOpenURL:url];
    if (canHandleOpenShareURL) {
        return YES;
    }

    return YES;
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
    
    [Appirater setAppId:@"1011236187"];
    
    // Instabug
#ifdef DEBUG
    [Instabug startWithToken:@"84e5be6250eaf585a69368e09fe6dca3" captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
    [Instabug setIsTrackingCrashes:NO];
    [Pingpp setDebugMode:YES];
    [Appirater setDebug:NO];
#else
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSString *receiptURLString = [receiptURL path];
    BOOL isRunningTestFlightBeta =  ([receiptURLString rangeOfString:@"sandboxReceipt"].location != NSNotFound);
    if (isRunningTestFlightBeta) {
        [Instabug startWithToken:@"84e5be6250eaf585a69368e09fe6dca3" captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
        [Instabug setIsTrackingCrashes:NO];
    }
    [Appirater setDebug:NO];
    
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
    
    [HHSocialMediaShareUtility sharedInstance];
    
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    
    [HHEventTrackingManager sharedManager];
    
}


// Respond to Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    if (handledByBranch) {
        if (![[HHAppDelegate topMostController] isKindOfClass:[HHLaunchImageViewController class]]) {
            [[HHLoadingViewUtility sharedInstance] showLoadingView];
        }
    }
    
    return handledByBranch;
}

+ (UIViewController *) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}



@end
