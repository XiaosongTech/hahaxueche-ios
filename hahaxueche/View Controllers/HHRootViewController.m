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
#import "HHMyProfileViewController.h"
#import "HHTrainingFieldService.h"
#import "HHUserAuthenticator.h"
#import "HHCoachMyProfileViewController.h"
#import "HHCoachScheduleViewController.h"
#import "HHStudentListViewController.h"

@interface HHRootViewController ()

@end

@implementation HHRootViewController

- (instancetype)initForStudent {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.view.backgroundColor = [UIColor clearColor];
        [[HHTrainingFieldService sharedInstance] fetchTrainingFieldsForCity:[HHUserAuthenticator sharedInstance].currentStudent.city completion:nil];
        [self initViewControllersForStudent];
    }
    return self;
}

- (instancetype)initForCoach {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.view.backgroundColor = [UIColor clearColor];
        [self initViewControllersForCoach];
    }
    return self;
}

- (void)initViewControllersForCoach {
    
    HHCoachScheduleViewController *coachScheduleVC = [[HHCoachScheduleViewController alloc] init];
    coachScheduleVC.coach = [HHUserAuthenticator sharedInstance].currentCoach;
    HHNavigationController *coachScheduleNavVC = [[HHNavigationController alloc] initWithRootViewController:coachScheduleVC];
    UITabBarItem *coachScheduleItem = [[UITabBarItem alloc] init];
    coachScheduleItem.image = [[UIImage imageNamed:@"calendar_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachScheduleItem.selectedImage = [[UIImage imageNamed:@"calendar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachScheduleItem.title = NSLocalizedString(@"练车时间", nil);
    coachScheduleNavVC.tabBarItem = coachScheduleItem;
    
    HHStudentListViewController *studentListVC = [[HHStudentListViewController alloc] init];
    HHNavigationController *studentListNavVC = [[HHNavigationController alloc] initWithRootViewController:studentListVC];
    UITabBarItem *studentListItem = [[UITabBarItem alloc] init];
    studentListItem.image = [[UIImage imageNamed:@"reservation_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    studentListItem.selectedImage = [[UIImage imageNamed:@"reservation_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    studentListItem.title = NSLocalizedString(@"我的学员", nil);
    studentListNavVC.tabBarItem = studentListItem;
    
    HHCoachMyProfileViewController *coachProfileVC = [[HHCoachMyProfileViewController alloc] init];
    HHNavigationController *coachProfileNavVC = [[HHNavigationController alloc] initWithRootViewController:coachProfileVC];
    UITabBarItem *coachProfileItem = [[UITabBarItem alloc] init];
    coachProfileItem.image = [[UIImage imageNamed:@"profile_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachProfileItem.selectedImage = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachProfileItem.title = NSLocalizedString(@"我的页面", nil);
    coachProfileNavVC.tabBarItem = coachProfileItem;
    
    NSArray *viewControllers = @[coachScheduleNavVC, studentListNavVC, coachProfileNavVC];
    self.viewControllers = viewControllers;
    
}

- (void)initViewControllersForStudent {
    HHHomePageViewController *homePageVC = [[HHHomePageViewController alloc] init];
    HHNavigationController *HomePageNavVC = [[HHNavigationController alloc] initWithRootViewController:homePageVC];
    UITabBarItem *homePageItem = [[UITabBarItem alloc] init];
    homePageItem.image = [[UIImage imageNamed:@"car_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageItem.selectedImage = [[UIImage imageNamed:@"car_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageItem.title = NSLocalizedString(@"哈哈学车", nil);
    HomePageNavVC.tabBarItem = homePageItem;
    
    HHCoachListViewController *coachListVC = [[HHCoachListViewController alloc] init];
    HHNavigationController *coachListeNavVC = [[HHNavigationController alloc] initWithRootViewController:coachListVC];
    UITabBarItem *coachListItem = [[UITabBarItem alloc] init];
    coachListItem.image = [[UIImage imageNamed:@"list_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachListItem.selectedImage = [[UIImage imageNamed:@"list_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachListItem.title = NSLocalizedString(@"寻找教练", nil);
    coachListeNavVC.tabBarItem = coachListItem;
    
    HHBookViewController *bookVC = [[HHBookViewController alloc] init];
    HHNavigationController *bookNavVC = [[HHNavigationController alloc] initWithRootViewController:bookVC];
    UITabBarItem *bookItem = [[UITabBarItem alloc] init];
    bookItem.image = [[UIImage imageNamed:@"calendar_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bookItem.selectedImage = [[UIImage imageNamed:@"calendar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bookItem.title = NSLocalizedString(@"预约时间", nil);
    bookNavVC.tabBarItem = bookItem;
    
    HHMyReservationViewController *myReservationVC = [[HHMyReservationViewController alloc] init];
    HHNavigationController *myReservationNavVC = [[HHNavigationController alloc] initWithRootViewController:myReservationVC];
    UITabBarItem *myReservationItem = [[UITabBarItem alloc] init];
    myReservationItem.image = [[UIImage imageNamed:@"reservation_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myReservationItem.selectedImage = [[UIImage imageNamed:@"reservation_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myReservationItem.title = NSLocalizedString(@"我的预约", nil);
    myReservationNavVC.tabBarItem = myReservationItem;
    
    HHMyProfileViewController *myProfileVC = [[HHMyProfileViewController alloc] init];
    HHNavigationController *myProfileNavVC = [[HHNavigationController alloc] initWithRootViewController:myProfileVC];
    UITabBarItem *myProfileItem = [[UITabBarItem alloc] init];
    myProfileItem.image = [[UIImage imageNamed:@"profile_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myProfileItem.selectedImage = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myProfileItem.title = NSLocalizedString(@"我的页面", nil);
    myProfileNavVC.tabBarItem = myProfileItem;
    
    NSArray *viewControllers = @[HomePageNavVC, coachListeNavVC, bookNavVC, myReservationNavVC, myProfileNavVC];
    self.viewControllers = viewControllers;

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

}


@end
