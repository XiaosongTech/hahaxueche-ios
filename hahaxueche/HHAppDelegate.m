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
    UIImageView *reservationView = [[UIImageView alloc] initWithImage:coachListImage];
    UIImageView *bookView = [[UIImageView alloc] initWithImage:coachListImage];
    NSArray *barItems = @[coachListView, reservationView, bookView];
    
    NSArray *controllers = @[
                             [[HHCoachListViewController alloc] init],
                             [[HHCoachListViewController alloc] init],
                             [[HHCoachListViewController alloc] init]];
    
    SLPagingViewController *pageViewController  =  [[SLPagingViewController alloc] initWithNavBarItems:barItems controllers:controllers showPageControl:NO];


    pageViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
    [pageViewController setNavigationBarColor:[UIColor clearColor]];
    float minX = 45.0;

    pageViewController.pagingViewMoving = ^(NSArray *subviews){
        float mid  = [UIScreen mainScreen].bounds.size.width/2 - minX;
        float midM = [UIScreen mainScreen].bounds.size.width - minX;
        for(UIImageView *v in subviews){
            UIColor *c = [UIColor HHOrange];
            if(v.frame.origin.x > minX
               && v.frame.origin.x < mid)
                // Left part
                c = [UIColor gradient:v.frame.origin.x
                                  top:minX+1
                               bottom:mid-1
                                 init:[UIColor HHOrange]
                                 goal:[UIColor HHOrange]];
            else if(v.frame.origin.x > mid
                    && v.frame.origin.x < midM)
                // Right part
                c = [UIColor gradient:v.frame.origin.x
                                  top:mid+1
                               bottom:midM-1
                                 init:[UIColor HHOrange]
                                 goal:[UIColor HHOrange]];
            else if(v.frame.origin.x == mid)
                c = [UIColor HHOrange];
            v.tintColor= c;
        }
    };
    HHNavigationController *navVC = [[HHNavigationController alloc] initWithRootViewController:pageViewController];
    [self.window setRootViewController:navVC];
}

@end
