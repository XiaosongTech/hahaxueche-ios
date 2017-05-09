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
#import "HHCoachDetailViewController.h"
#import "QYSDK.h"
#import "HHNetworkUtility.h"
#import "HHCoachDetailViewController.h"
#import <LinkedME_iOS/LinkedME.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import <UserNotifications/UserNotifications.h>
#import "HHWebViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHTestStartViewController.h"
#import "HHVouchersViewController.h"
#import "HHGuardCardViewController.h"
#import "HHClubPostDetailViewController.h"
#import "HHInsuranceViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kAliPushAppKey          @"23260416"
#define kAliPushAppSecret       @"996121506d96c60827a917c2ca26ab14"


typedef void (^HHAppDelegateCompletion)();

static NSString *const kMapServiceKey = @"b1f6d0a0e2470c6a1145bf90e1cdebe4";

@interface HHAppDelegate () <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UNUserNotificationCenter *notificationCenter;
@property (nonatomic, strong) NSDictionary *notificationUserInfo;

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HHLaunchImageViewController *launchVC = [[HHLaunchImageViewController alloc] init];
    [self.window setRootViewController:launchVC];
    
    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
    [[HHStudentStore sharedInstance] createGuestStudent];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *cityId = [defaults objectForKey:@"userSelectedCity"];
    if (cityId) {
        [HHStudentStore sharedInstance].selectedCityId = cityId;
    } else {
        [HHStudentStore sharedInstance].selectedCityId = @(0);
    }
    
    [[HHConstantsStore sharedInstance] getCityWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:nil];
    
    [[HHNetworkUtility sharedManager] monitorNetwork];
    
    [[HHConstantsStore sharedInstance] getConstantsWithCompletion:^(HHConstants *constants) {
        if (constants) {
            if ([[HHUserAuthService sharedInstance] getSavedUser] && [HHKeychainStore getSavedAccessToken]) {
                HHStudent *savedStudent = [[[HHUserAuthService sharedInstance] getSavedUser] student];
                [[HHUserAuthService sharedInstance] isTokenValid:savedStudent.cellPhone completion:^(BOOL valid) {
                    if (valid) {
                        [[HHStudentService sharedInstance] fetchStudentWithId:savedStudent.studentId completion:^(HHStudent *student, NSError *error) {
                            if (!error) {
                                if (!student) {
                                    launchVC.desVC = rootVC;
                                    [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                                } else {
                                    [HHStudentStore sharedInstance].currentStudent = student;
                                    if (!student.name || !student.cityId) {
                                        // Student created, but not set up yet
                                        HHAccountSetupViewController *accountVC = [[HHAccountSetupViewController alloc] initWithStudentId:student.studentId];
                                        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:accountVC];
                                        launchVC.desVC = navVC;
                                        [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                                        
                                    } else {
                                        launchVC.desVC = rootVC;
                                        [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                                    }
                                    
                                }
                            } else {
                                launchVC.desVC = rootVC;
                                [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                            }
                        }];
                    } else {
                        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
                        UINavigationController *introNavVC = [[UINavigationController alloc] initWithRootViewController:introVC];
                        
                        launchVC.desVC = introNavVC;
                        [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
                    }
                }];
                
            } else {
                launchVC.desVC = rootVC;
                [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
            }
        } else {
            launchVC.desVC = rootVC;
            [self handleLinkedMeLinkWithLaunchOptions:launchOptions];
        }
       
    }];
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    [self setupAllThirdPartyServices];
    [self setAppearance];
    
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    
    [self registerMessageReceive];
    [CloudPushSDK sendNotificationAck:launchOptions];

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
                    [self jumpToVC:coachVC completion:nil];
                }
            } else if ([HHParam[@"type"] isEqualToString: @"article"]) {
                NSString *articleId = HHParam[@"id"];
                if (articleId) {
                    HHClubPostDetailViewController *vc = [[HHClubPostDetailViewController alloc] initWithPostId:articleId];
                    [self jumpToVC:vc completion:nil];
                }
            } else if ([HHParam[@"type"] isEqualToString:@"refer_record"]) {
                HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
                [self jumpToVC:vc completion:^{
                    [vc showReferralDetailVC];
                }];
            } else if ([HHParam[@"type"] isEqualToString:@"test_practice"]) {
                HHTestStartViewController *vc = [[HHTestStartViewController alloc] init];
                [self jumpToVC:vc completion:nil];
                
            } else if ([HHParam[@"type"] isEqualToString:@"coach_list"]) {
                HHRootViewController *rootVC = [[HHRootViewController alloc] initWithDefaultIndex:TabBarItemCoach];
                self.window.rootViewController = rootVC;

            } else if ([HHParam[@"type"] isEqualToString:@"peifubao"]) {
                HHInsuranceViewController *insuranceVC = [[HHInsuranceViewController alloc] init];
                [self jumpToVC:insuranceVC completion:nil];

            } else {
                if (self.notificationUserInfo) {
                    [self handleSchema:self.notificationUserInfo];
                }
                
            }
        }

    }];
}

- (void)handleSchema:(NSDictionary *)userInfo {
    if (userInfo[@"url"]) {
        HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:userInfo[@"url"]]];
        [self jumpToVC:webVC completion:nil];
    } else if (self.notificationUserInfo[@"page"]) {
        NSString *page = self.notificationUserInfo[@"page"];
        if ([page isEqualToString:@"ReferPage"]) {
            HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
            [self jumpToVC:vc completion:nil];
            
        } else if ([page isEqualToString:@"CourseOneGuardPage"]) {
            HHGuardCardViewController *vc = [[HHGuardCardViewController alloc] init];
            [self jumpToVC:vc completion:nil];
            
        } else if ([page isEqualToString:@"VoucherPage"]) {
            HHVouchersViewController *vc = [[HHVouchersViewController alloc] init];
            [self jumpToVC:vc completion:nil];
            
            
        } else if ([page isEqualToString:@"TestPage"]) {
            HHTestStartViewController *vc = [[HHTestStartViewController alloc] init];
            [self jumpToVC:vc completion:nil];
            
        }
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
   
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_topnav"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

- (void)setupAllThirdPartyServices {
    
    
#ifdef DEBUG
    [Pingpp setDebugMode:YES];
#endif
    
    //Umeng
    [HHEventTrackingManager sharedManager];
    
    //SDWebImage
    [SDWebImageManager sharedManager].imageCache.maxCacheSize = 20000000;
    [[[SDWebImageManager sharedManager] imageDownloader] setMaxConcurrentDownloads:10];
    [[[SDWebImageManager sharedManager] imageDownloader] setExecutionOrder:SDWebImageDownloaderLIFOExecutionOrder];
    
    //高德
    [AMapServices sharedServices].enableHTTPS = YES;
    [AMapServices sharedServices].apiKey = kMapServiceKey;
    
    //Openshare
    [HHSocialMediaShareUtility sharedInstance];
    
    //SSKeychain
    [SAMKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    
    //七牛
    [[QYSDK sharedSDK] registerAppId:@"2f328da38ac77ce6d796c2977248f7e2" appName:@"hahaxueche-ios"];

}

+ (UIViewController *) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


#pragma mark - AliPush & Notification Delegate Methods

- (void)initCloudPush {
#ifdef DEBUG
    [CloudPushSDK turnOnDebug];
#endif
    
    // SDK初始化
    [CloudPushSDK asyncInit:kAliPushAppKey appSecret:kAliPushAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                [application registerForRemoteNotifications];
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}

/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (userInfo) {
            [self handleSchema:userInfo];
        }
    } else {
        if (userInfo) {
            self.notificationUserInfo = userInfo;
        }
    }
    [CloudPushSDK sendNotificationAck:userInfo];
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus {
    [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            NSLog(@"User authed.");
        } else {
            NSLog(@"User denied.");
        }
    }];
}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    
    // 通知弹出，且带有声音、内容和角标
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (userInfo) {
            [self handleSchema:userInfo];
        }
    } else {
        if (userInfo) {
            self.notificationUserInfo = userInfo;
        }
    }
    
    [CloudPushSDK sendNotificationAck:userInfo];
}


- (void)jumpToVC:(UIViewController *)viewController completion:(HHAppDelegateCompletion)completion {
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [[HHAppDelegate topMostController] presentViewController:navVC animated:YES completion:completion];
}

- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}





@end
