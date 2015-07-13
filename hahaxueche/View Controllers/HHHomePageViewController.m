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
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "HHButton.h"

@interface HHHomePageViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *imageGalleryView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) HHButton *oneClickButton;

@end

@implementation HHHomePageViewController


- (void)viewDidLoad {
    self.title = @"哈哈学车";
    self.imagesArray = @[[UIImage imageNamed:@"austin1.jpg"], [UIImage imageNamed:@"austin2.jpg"], [UIImage imageNamed:@"austin3.jpg"]];
    self.imageGalleryView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:self.imagesArray];
    self.imageGalleryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageGalleryView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.imageGalleryView.backgroundColor = [UIColor clearColor];
    self.imageGalleryView.autoScroll = NO;;
    self.imageGalleryView.delegate = self;
    [self.view addSubview:self.imageGalleryView];
    
    self.oneClickButton = [[HHButton alloc] initSolidButtonWithTitle:@"一键选教练" textColor:[UIColor whiteColor] font:[UIFont fontWithName:@"SourceHanSansSC-Heavy" size:30]];
    self.oneClickButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.oneClickButton];
    
    [self autoLayoutSubviews];
}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.imageGalleryView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.imageGalleryView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.imageGalleryView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.imageGalleryView multiplier:0 constant:200.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.oneClickButton toView:self.imageGalleryView constant:30.0f],
                             [HHAutoLayoutUtility setCenterX:self.oneClickButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.oneClickButton multiplier:1.0f constant:-40.0f],
                             [HHAutoLayoutUtility setViewHeight:self.oneClickButton multiplier:0 constant:80.0f],
                            ];
    [self.view addConstraints:constraints];
}



#pragma mark SDCycleScrollViewDelegate Methods

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.imagesArray[index];
    imageInfo.referenceRect = self.imageGalleryView.frame;
    imageInfo.referenceView = self.imageGalleryView;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
