//
//  HHNavigationController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHNavigationController.h"
#import "UIColor+HHColor.h"

@implementation HHNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupVC];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setupVC];
    }
    return self;
}

- (void)setupVC {
    //self.navigationBar.barTintColor = [UIColor colorWithRed:1 green:0.69 blue:0.25 alpha:1];
}

@end
