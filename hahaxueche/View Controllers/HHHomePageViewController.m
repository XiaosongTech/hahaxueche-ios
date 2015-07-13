//
//  HHHomePageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHHomePageViewController.h"
#import "SDCycleScrollView.h"
#import "HHAutoLayoutUtility.h"

@interface HHHomePageViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *imageGalleryView;
@property (nonatomic, strong) NSArray *imagesArray;

@end

@implementation HHHomePageViewController


- (void)viewDidLoad {
    self.imagesArray = @[[UIImage imageNamed:@"austin1.jpg"], [UIImage imageNamed:@"austin2.jpg"], [UIImage imageNamed:@"austin3.jpg"]];
    self.imageGalleryView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:self.imagesArray];
    self.imageGalleryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageGalleryView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.imageGalleryView.backgroundColor = [UIColor clearColor];
    self.imageGalleryView.autoScrollTimeInterval = 5.0f;
    self.imageGalleryView.delegate = self;
    [self.view addSubview:self.imageGalleryView];
    [self autoLayoutSubviews];
}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.imageGalleryView constant:20.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.imageGalleryView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.imageGalleryView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.imageGalleryView multiplier:0 constant:200.0f],
                            ];
    [self.view addConstraints:constraints];
}



#pragma mark SDCycleScrollViewDelegate Methods

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

@end
