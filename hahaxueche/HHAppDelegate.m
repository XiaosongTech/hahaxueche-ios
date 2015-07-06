//
//  HHAppDelegate.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/4/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAppDelegate.h"
#import "SLPagingViewController.h"
#import "HHCoachListViewController.h"
#import "UIColor+HHColor.h"
#import "UIColor+SLAddition.h"
#import "HHNavigationController.h"
#import "UIView+HHRect.h"
#import "HHBookViewController.h"

@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initPageViewController];
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    [self.window makeKeyAndVisible];
    [self setWindow:self.window];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)initPageViewController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIImage *coachListImage = [UIImage imageNamed:@"profile"];
    
    UIImageView *coachListView = [[UIImageView alloc] initWithImage:coachListImage];
    coachListView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *reservationView = [[UIImageView alloc] initWithImage:coachListImage];
    reservationView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *bookView = [[UIImageView alloc] initWithImage:coachListImage];
    bookView.contentMode = UIViewContentModeScaleAspectFit;
    

    NSArray *barItems = @[coachListView, reservationView, bookView];
    
    NSArray *controllers = @[
                             [[HHCoachListViewController alloc] init],
                             [[HHBookViewController alloc] init],
                             [[HHCoachListViewController alloc] init]];
    
    SLPagingViewController *pageViewController  =  [[SLPagingViewController alloc] initWithNavBarItems:barItems controllers:controllers showPageControl:NO];


    pageViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
    [pageViewController setNavigationBarColor:[UIColor clearColor]];
    __weak SLPagingViewController *weakVC = pageViewController;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"哈哈学车";
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [titleLabel sizeToFit];
    
    
    pageViewController.pagingViewMoving = ^(NSArray *subviews) {
        [titleLabel removeFromSuperview];
    };
    pageViewController.didChangedPage = ^(NSInteger currentPageIndex) {
        int i = 0;
        for(UIImageView *v in barItems) {
            v.image = coachListImage;
            if(i == currentPageIndex) {
                v.image = [UIImage imageNamed:nil];
                [titleLabel sizeToFit];
                [weakVC.navigationBarView addSubview:titleLabel];
                titleLabel.center = weakVC.navigationBarView.center;
            }
            i++;
        }
    };

    
    HHNavigationController *navVC = [[HHNavigationController alloc] initWithRootViewController:pageViewController];
    [self.window setRootViewController:navVC];
}

@end
