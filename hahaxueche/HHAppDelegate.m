//
//  HHAppDelegate.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/4/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAppDelegate.h"
#import "HHEventTrackingManager.h"
#import "SDWebImage/SDWebImageManager.h"
#import <SAMKeychain/SAMKeychain.h>
#import "HHIntroViewController.h"
#import "UIColor+HHColor.h"
#import "HHConstantsStore.h"
#import "HHKeychainStore.h"
#import "HHUserAuthService.h"
#import "HHStudentStore.h"
#import "HHRootViewController.h"
#import "HHAccountSetupViewController.h"
#import "HHLaunchImageViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "HHSocialMediaShareUtility.h"
#import <Pingpp/Pingpp.h>
#import "HHStudentService.h"
#import "HHToastManager.h"
#import <Appirater.h>
#import "HHCoachDetailViewController.h"
#import "HHLoadingViewUtility.h"
#import <Harpy/Harpy.h>
#import "QYSDK.h"
#import "HHNetworkUtility.h"
#import "HHCoachDetailViewController.h"
#import "HHPersonalCoachDetailViewController.h"
#import "GeTuiSdk.h"
#import <LinkedME_iOS/LinkedME.h>

#define kGtAppId           @"iMahVVxurw6BNr7XSn9EF2"
#define kGtAppKey          @"yIPfqwq6OMAPp6dkqgLpG5"
#define kGtAppSecret       @"G0aBqAD6t79JfzTB6Z5lo5"


static NSString *const kMapServiceKey = @"b1f6d0a0e2470c6a1145bf90e1cdebe4";

@interface HHAppDelegate () <HarpyDelegate, GeTuiSdkDelegate>

@property (nonatomic, strong) __block UIViewController *finalRootVC;

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HHLaunchImageViewController *launchVC = [[HHLaunchImageViewController alloc] init];
    [self.window setRootViewController:launchVC];
    
    
    HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
    __block UINavigationController *introNavVC = [[UINavigationController alloc] initWithRootViewController:introVC];
    
    self.finalRootVC = introNavVC;
    
    [[HHNetworkUtility sharedManager] monitorNetwork];
    
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
                                    self.finalRootVC = navVC;
                                    [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                            
                                } else {
                                    // Get the saved student object, we lead user to rootVC
                                    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
                                    self.finalRootVC = rootVC;
                                    self.window.rootViewController = self.finalRootVC;
                                    [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                                }
                            } else {
                                self.window.rootViewController = self.finalRootVC;
                                [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                            }
                        }];
                    } else {
                        self.window.rootViewController = self.finalRootVC;
                        [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                    }
                }];
                
            } else {
                self.window.rootViewController = self.finalRootVC;
                [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
            }
        } else {
            self.window.rootViewController = self.finalRootVC;
            [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
        }
       
    }];
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    [self setupAllThirdPartyServices];
    [self setAppearance];
    
    return YES;
}

- (void)handleLinkedMeLinkWithLaunchOptions:(NSDictionary *)launchOptions {
    LinkedME* linkedme = [LinkedME getInstance];
    [linkedme initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:NO deepLinkHandler:^(NSDictionary* params, NSError* error) {
        if (!error && params) {
            NSDictionary *HHParam = params[@"$control"];
            if ([HHParam[@"type"] isEqualToString: @"coach_detail"]) {
                NSString *coachId = HHParam[@"coach_id"];
                if (coachId) {
                    HHCoachDetailViewController *coachVC = [[HHCoachDetailViewController alloc] initWithCoachId:coachId];
                    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:coachVC];
                    [[HHAppDelegate topMostController] presentViewController:navVC animated:YES completion:nil];
                }
            } else if ([HHParam[@"type"] isEqualToString: @"training_partner_detail"]) {
                NSString *coachId = HHParam[@"training_partner_id"];
                HHPersonalCoachDetailViewController *coachVC = [[HHPersonalCoachDetailViewController alloc] initWithCoachId:coachId];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:coachVC];
                [[HHAppDelegate topMostController] presentViewController:navVC animated:YES completion:nil];
                
            }
        }
    }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    return ([Pingpp handleOpenURL:url withCompletion:nil] || [OpenShare handleOpenURL:url] || [[LinkedME getInstance] handleDeepLink:url]);
}

// Respond to URI scheme links
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return ([Pingpp handleOpenURL:url withCompletion:nil] || [OpenShare handleOpenURL:url] || [[LinkedME getInstance] handleDeepLink:url]);
}

// Respond to Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    return [[LinkedME getInstance] continueUserActivity:userActivity];;
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
    
    //Appirater
    [Appirater setAppId:@"1011236187"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:0];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
#ifdef DEBUG
    [Pingpp setDebugMode:YES];
    [Appirater setDebug:YES];
#endif
    
    //Umeng
    [HHEventTrackingManager sharedManager];
    
    //SDWebImage
    [SDWebImageManager sharedManager].imageCache.maxCacheSize = 20000000;
    [[[SDWebImageManager sharedManager] imageDownloader] setMaxConcurrentDownloads:10];
    [[[SDWebImageManager sharedManager] imageDownloader] setExecutionOrder:SDWebImageDownloaderLIFOExecutionOrder];
    
    //高德
    [AMapServices sharedServices].apiKey =kMapServiceKey;
    
    //Openshare
    [HHSocialMediaShareUtility sharedInstance];
    
    //SSKeychain
    [SAMKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    
    //七牛
    [[QYSDK sharedSDK] registerAppId:@"2f328da38ac77ce6d796c2977248f7e2" appName:@"hahaxueche-ios"];
    
    //Harpy
    [[Harpy sharedInstance] setAppID:@"1011236187"];
    [[Harpy sharedInstance] setPresentingViewController:self.window.rootViewController];
    [[Harpy sharedInstance] setDelegate:self];
    [[Harpy sharedInstance] setAppName:@"哈哈学车"];
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
    [[Harpy sharedInstance] setDebugEnabled:YES];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setCountryCode:@"CN"];
    [[Harpy sharedInstance] checkVersion];
    
    //个推
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNS
    [self registerRemoteNotification];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

+ (UIViewController *) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

/** 注册APNS */
- (void)registerRemoteNotification {
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}




@end
