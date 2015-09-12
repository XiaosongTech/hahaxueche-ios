//
//  HHFirstLaunchGuideViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHFirstLaunchGuideViewController.h"
#import "HHScrollImageGallery.h"
#import "HHAutoLayoutUtility.h"
#import "HHLoginSignupViewController.h"

@interface HHFirstLaunchGuideViewController ()

@property (nonatomic, strong) HHScrollImageGallery *imageView;
@property (nonatomic, strong) NSArray *images;

@end

@implementation HHFirstLaunchGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.images = @[[UIImage imageNamed:@"guide1.jpg"], [UIImage imageNamed:@"guide2.jpg"], [UIImage imageNamed:@"guide3.jpg"], [UIImage imageNamed:@"guide4.jpg"]];
    self.imageView  = [[HHScrollImageGallery alloc] initWithImages:self.images];
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.imageView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToRootView)];
    UIImageView *lastImageView = [self.imageView.imageViews lastObject];
    lastImageView.userInteractionEnabled = YES;
    [lastImageView addGestureRecognizer:tapRecognizer];
    
}

- (void)jumpToRootView {
    HHLoginSignupViewController *loginSignupVC = [[HHLoginSignupViewController alloc] init];
    [self presentViewController:loginSignupVC animated:YES completion:nil];
}


@end
