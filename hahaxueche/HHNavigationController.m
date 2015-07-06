//
//  HHNavigationController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHNavigationController.h"

@implementation HHNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setNavBarTranslucent];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setNavBarTranslucent];
    }
    return self;
}

- (void)setNavBarTranslucent {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}

@end
