//
//  HHRootViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TabBarItemHomePageView,
    TabBarItemCoachListView,
    TabBarItemBookView,
    TabBarItemMyReservationView,
    TabBarItemMyProfileView,
} TabBarItem;

@interface HHRootViewController : UITabBarController <UITabBarControllerDelegate>

- (instancetype)initForStudent;
- (instancetype)initForCoach;


@end
