//
//  HHCoachScheduleViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachScheduleViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachAddTimeViewController.h"

@interface HHCoachScheduleViewController ()

@end

@implementation HHCoachScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = nil;
    self.title = NSLocalizedString(@"练车时间", nil);
    
    UIBarButtonItem *addTimeBarButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"添加时间", nil) action:@selector(addTime) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = addTimeBarButton;
}

- (void)addTime {
    HHCoachAddTimeViewController *addTimeVC = [[HHCoachAddTimeViewController alloc] init];
    addTimeVC.successCompletion = ^(){
        [super fetchSchedulesWithCompletion:nil];
    };
    [self.navigationController pushViewController:addTimeVC animated:YES];
}

#pragma -mark Show TabBar
- (BOOL)hidesBottomBarWhenPushed {
    return (self.navigationController.topViewController != self);
}


@end
