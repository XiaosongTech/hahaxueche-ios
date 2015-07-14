//
//  HHProfileSetupViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHProfileSetupViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHRootViewController.h"

@interface HHProfileSetupViewController ()

@end

@implementation HHProfileSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *doneButton = [UIBarButtonItem buttonItemWithTitle:@"完成" action:@selector(doneButtonPressed) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    
     UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:@"取消" action:@selector(cancelButtonPressed) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.title = @"2/2";
    
}


- (void)doneButtonPressed {
    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
