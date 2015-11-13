//
//  HHAppDelegate.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/4/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAppDelegate.h"
#import "HHNavigationController.h"
#import "HHRootViewController.h"
#import "UIColor+HHColor.h"
#import "HHLoginSignupViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HHUser.h"
#import "HHStudent.h"
#import <SMS_SDK/SMSSDK.h>
#import "HHCoach.h"
#import "HHTrainingField.h"
#import "HHUserAuthenticator.h"
#import "HHProfileSetupViewController.h"
#import "HHTrainingFieldService.h"
#import "HHCoachSchedule.h"
#import "HHScheduleService.h"
#import "HHCoachSchedule.h"
#import "HHReview.h"
#import "HHTransaction.h"
#import "HHPaymentStatus.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HHToastUtility.h"
#import "HHTransfer.h"
#import "HHReferral.h"
#import "HHFirstLaunchGuideViewController.h"
#import "HHStartAppLoadingViewController.h"
#import "HHBanner.h"
#import "HHLoadingView.h"
#import "Appirater.h"
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <Instabug/Instabug.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HHEventTrackingManager.h"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kLeanCloudStagingAppID @"cr9pv6bp9nlr1xrtl36slyxt0hgv6ypifso9aocxwas2fugq"
#define kLeanCloudStagingAppKey @"2ykqwhzhfrzhjn3o9bj7rizb8qd75ym3f0lez1d8fcxmn2k3"

#define kLeanCloudProductionAppID @"iylpzs1kdohzr04ly3w837schvelubnbpttu48iur1h2wzps"
#define kLeanCloudProductionAppKey @"w4k4u22ps3cud54ipm2pofbxj93w1qmfo78ks5robp9ct2u2"



@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAllServices];
    [self setAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        HHFirstLaunchGuideViewController *guideVC = [[HHFirstLaunchGuideViewController alloc] init];
        [self.window setRootViewController:guideVC];
        [self.window makeKeyAndVisible];
        [self setAppearance];
        [self setWindow:self.window];
        return YES;

    }
    
    HHStartAppLoadingViewController *vc = [[HHStartAppLoadingViewController alloc] init];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
    [self setAppearance];
    [self setWindow:self.window];
    
    if ([HHUser currentUser]) {
        [HHUserAuthenticator sharedInstance].currentUser = [HHUser currentUser];
        if ([[HHUserAuthenticator sharedInstance].currentUser.type isEqualToString:kStudentTypeValue]) {
            [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:[HHUserAuthenticator sharedInstance].currentUser.objectId completion:^(HHStudent *student, NSError *error) {
                if (!error) {
                    HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
                    [self.window setRootViewController:rootVC];
                    [self.window setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1]];
                    [self.window makeKeyAndVisible];
                    [self setAppearance];
                    [self setWindow:self.window];
                } else {
                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"登陆失败", nil) isError:YES];
                    [self jumpToLoginSignupView];
                }
            }];

        } else {
            [[HHUserAuthenticator sharedInstance] fetchAuthedCoachWithId:[HHUserAuthenticator sharedInstance].currentUser.objectId completion:^(HHCoach *coach, NSError *error) {
                if (!error) {
                    HHRootViewController *rootVC = [[HHRootViewController alloc] initForCoach];
                    [self.window setRootViewController:rootVC];
                    [self.window setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1]];
                    [self.window makeKeyAndVisible];
                    [self setAppearance];
                    [self setWindow:self.window];
                } else {
                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"登陆失败", nil) isError:YES];
                    [self jumpToLoginSignupView];
                }
            }];
        }
        
    } else {
        [self jumpToLoginSignupView];
    }
    return YES;
   
}

- (void)jumpToLoginSignupView {
    HHLoginSignupViewController *loginSignupVC = [[HHLoginSignupViewController alloc] init];
    [self.window setRootViewController:loginSignupVC];
    [self.window setBackgroundColor:[UIColor HHLightGrayBackgroundColor]];
    [self.window makeKeyAndVisible];
    [self setAppearance];
    [self setWindow:self.window];
    [[HHUserAuthenticator sharedInstance] logout];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[HHLoadingView sharedInstance] hideLoadingView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)setAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor HHOrange],
                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]} forState:UIControlStateNormal];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    [[UINavigationBar appearance] setBarTintColor:[UIColor HHOrange]];
    [[UITabBar appearance] setTintColor:[UIColor HHOrange]];
    [[UITabBar appearance] setBarTintColor:[UIColor HHLightGrayBackgroundColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:10]} forState:UIControlStateNormal];
    
}

- (void)setupAllServices {
    [self leanCloudRegisterSubclass];
    [self setupSMSService];
    [self setupBackend];
    [self setInstabugService];
    [self setupFabric];
    [self setupUmeng];
}

- (void)setupFabric {
    [Fabric with:@[[Crashlytics class]]];

}

- (void)setupUmeng {
    [HHEventTrackingManager sharedManager];
}

- (void)setInstabugService {
    
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
}

- (void)setupSMSService {
    [SMSSDK registerApp:@"8e7f80c5c4e6" withSecret:@"1a8ed11da1f399a723950c47b084525e"];
    [SMSSDK enableAppContactFriends:NO];
}

- (void)leanCloudRegisterSubclass {
    [HHUser registerSubclass];
    [HHStudent registerSubclass];
    [HHCoach registerSubclass];
    [HHTrainingField registerSubclass];
    [HHCoachSchedule registerSubclass];
    [HHReview registerSubclass];
    [HHTransaction registerSubclass];
    [HHPaymentStatus registerSubclass];
    [HHTransfer registerSubclass];
    [HHReferral registerSubclass];
    [HHBanner registerSubclass];
}

- (void)setupBackend {
#if DEBUG
    [AVOSCloud setApplicationId:kLeanCloudStagingAppID
                      clientKey:kLeanCloudStagingAppKey];
#else
    [AVOSCloud setApplicationId:kLeanCloudProductionAppID
                      clientKey:kLeanCloudProductionAppKey];
    
    [Appirater setAppId:@"1011236187"];
    [Appirater setDaysUntilPrompt:10];
    [Appirater setUsesUntilPrompt:0];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
#endif
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      
                                                      if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                                                          [HHToastUtility showToastWitiTitle:NSLocalizedString(@"支付成功！", nil) isError:NO];
                                                      } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                                                           [HHToastUtility showToastWitiTitle:NSLocalizedString(@"您已取消支付。", nil) isError:YES];
                                                      } else {
                                                          [HHToastUtility showToastWitiTitle:NSLocalizedString(@"支付失败！", nil) isError:YES];
                                                      }
                                                      
                                                  }]; }
    
    return YES;
}

@end
