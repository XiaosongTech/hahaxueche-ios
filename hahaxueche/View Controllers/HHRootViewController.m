//
//  HHRootViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHRootViewController.h"
#import "HHNavigationController.h"
#import "HHHomePageViewController.h"
#import "HHCoachListViewController.h"
#import "HHBookViewController.h"
#import "HHMyReservationViewController.h"

@interface HHRootViewController ()

@end

@implementation HHRootViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.view.backgroundColor = [UIColor clearColor];
        [self initViewControllers];
    }
    return self;
}


- (void)initViewControllers {
    HHHomePageViewController *homePageVC = [[HHHomePageViewController alloc] init];
    HHNavigationController *HomePageNavVC = [[HHNavigationController alloc] initWithRootViewController:homePageVC];
    UITabBarItem *homePageItem = [[UITabBarItem alloc] init];
    homePageItem.image = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageItem.selectedImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageItem.title = NSLocalizedString(@"主页", nil);
    HomePageNavVC.tabBarItem = homePageItem;
    
    HHCoachListViewController *coachListVC = [[HHCoachListViewController alloc] init];
    HHNavigationController *coachListeNavVC = [[HHNavigationController alloc] initWithRootViewController:coachListVC];
    UITabBarItem *coachListItem = [[UITabBarItem alloc] init];
    coachListItem.image = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachListItem.selectedImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachListItem.title = NSLocalizedString(@"找教练", nil);
    coachListeNavVC.tabBarItem = coachListItem;
    
    HHBookViewController *bookVC = [[HHBookViewController alloc] init];
    HHNavigationController *bookNavVC = [[HHNavigationController alloc] initWithRootViewController:bookVC];
    UITabBarItem *bookItem = [[UITabBarItem alloc] init];
    bookItem.image = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bookItem.selectedImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bookItem.title = NSLocalizedString(@"主页", nil);
    bookNavVC.tabBarItem = bookItem;
    
    HHMyReservationViewController *myReservationVC = [[HHMyReservationViewController alloc] init];
    HHNavigationController *myReservationNavVC = [[HHNavigationController alloc] initWithRootViewController:myReservationVC];
    UITabBarItem *myReservationItem = [[UITabBarItem alloc] init];
    myReservationItem.image = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myReservationItem.selectedImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myReservationItem.title = NSLocalizedString(@"主页", nil);
    myReservationNavVC.tabBarItem = myReservationItem;
    
    NSArray *viewControllers = @[HomePageNavVC, coachListeNavVC, bookNavVC, myReservationNavVC];
    self.viewControllers = viewControllers;
    [[UITabBarItem appearance] setTitleTextAttributes:@{[UIFont boldSystemFontOfSize:10.0f]: NSFontAttributeName} forState:UIControlStateNormal];

}


@end
