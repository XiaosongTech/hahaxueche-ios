//
//  HHRootViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHRootViewController.h"
#import "HHHomePageViewController.h"
#import "HHFindCoachViewController.h"
#import "HHMyPageViewController.h"
#import "UIColor+HHColor.h"
#import "HHClubViewController.h"

@interface HHRootViewController ()

@end

@implementation HHRootViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBar.tintColor = [UIColor HHOrange];
        self.tabBar.barTintColor = [UIColor whiteColor];
        
        HHHomePageViewController *homePageVC = [[HHHomePageViewController alloc] init];
        UINavigationController *homePageNavVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
        UITabBarItem *homePageItem = [[UITabBarItem alloc] init];
        homePageItem.image = [[UIImage imageNamed:@"ic_bottombar_haha_normal_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homePageItem.selectedImage = [[UIImage imageNamed:@"ic_bottombar_haha_hold_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homePageItem.title = @"哈哈学车";
        homePageNavVC.tabBarItem = homePageItem;
        
        HHFindCoachViewController *findCoachVC = [[HHFindCoachViewController alloc] init];
        UINavigationController *findCoachNavVC = [[UINavigationController alloc] initWithRootViewController:findCoachVC];
        UITabBarItem *findCoachItem = [[UITabBarItem alloc] init];
        findCoachItem.image = [[UIImage imageNamed:@"ic_bottombar_list_normal_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        findCoachItem.selectedImage = [[UIImage imageNamed:@"ic_bottombar_list_hold_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        findCoachItem.title = @"寻找教练";
        findCoachNavVC.tabBarItem = findCoachItem;
        
        
        HHClubViewController *clubVC = [[HHClubViewController alloc] init];
        UINavigationController *clubNavVC = [[UINavigationController alloc] initWithRootViewController:clubVC];
        UITabBarItem *clubItem = [[UITabBarItem alloc] init];
        clubItem.image = [[UIImage imageNamed:@"xiaohaclub"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        clubItem.selectedImage = [[UIImage imageNamed:@"xiaohaclub_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        clubItem.title = @"小哈俱乐部";
        clubNavVC.tabBarItem = clubItem;
        
        
        HHMyPageViewController *myPageVC = [[HHMyPageViewController alloc] init];
        UINavigationController *myPageNavVC = [[UINavigationController alloc] initWithRootViewController:myPageVC];
        UITabBarItem *myPageItem = [[UITabBarItem alloc] init];
        myPageItem.image = [[UIImage imageNamed:@"ic_bottombar_mypage_normal_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        myPageItem.selectedImage = [[UIImage imageNamed:@"ic_bottombar_mypage_hold_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        myPageItem.title = @"我的页面";
        myPageNavVC.tabBarItem = myPageItem;
        
        
        NSArray *viewControllers = @[homePageNavVC, findCoachNavVC, clubNavVC, myPageNavVC];
        self.viewControllers = viewControllers;
        
        self.selectedIndex = TabBarItemHomePage;
        
    }
    return self;
}

@end
