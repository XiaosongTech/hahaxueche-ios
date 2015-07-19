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
#import "UIColor+HHColor.h"
#import "HHRootViewController.h"

@interface HHHomePageViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *imageGalleryView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) HHButton *oneClickButton;
@property (nonatomic, strong) HHButton *stepOneButton;
@property (nonatomic, strong) HHButton *stepTwoButton;
@property (nonatomic, strong) HHButton *stepThreeButton;
@property (nonatomic, strong) UILabel *stepOneLabel;
@property (nonatomic, strong) UILabel *stepTwoLabel;
@property (nonatomic, strong) UILabel *stepThreeLabel;

@end

@implementation HHHomePageViewController


- (void)viewDidLoad {
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imagesArray = @[[UIImage imageNamed:@"austin1.jpg"], [UIImage imageNamed:@"austin2.jpg"], [UIImage imageNamed:@"austin3.jpg"]];
    self.imageGalleryView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:self.imagesArray];
    self.imageGalleryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageGalleryView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.imageGalleryView.backgroundColor = [UIColor clearColor];
    self.imageGalleryView.autoScroll = NO;;
    self.imageGalleryView.delegate = self;
    [self.view addSubview:self.imageGalleryView];
    
    self.oneClickButton = [[HHButton alloc] initSolidButtonWithTitle:@"一 键 找 教 练" textColor:[UIColor whiteColor] font:[UIFont fontWithName:@"SourceHanSansSC-Heavy" size:30.0f]];
    self.oneClickButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.oneClickButton];
    
    self.stepOneButton = [self createButtonWithTitle:@"1"];
    self.stepTwoButton = [self createButtonWithTitle:@"2"];
    self.stepThreeButton = [self createButtonWithTitle:@"3"];
    
    self.stepOneLabel = [self createLabelWithTitle:@"选择教练" textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:12]];
    
    self.stepTwoLabel = [self createLabelWithTitle:@"预约练车" textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:12]];
    
    self.stepThreeLabel = [self createLabelWithTitle:@"查看预约" textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:12]];
    
    [self autoLayoutSubviews];
}

- (HHButton *)createButtonWithTitle:(NSString *)title {
    HHButton *button = [[HHButton alloc] initThinBorderButtonWithTitle:title textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Heavy" size:20.0f] borderColor:[UIColor HHOrange] backgroundColor:[UIColor clearColor]];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(stepButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (UILabel *)createLabelWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self.view addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.imageGalleryView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.imageGalleryView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.imageGalleryView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.imageGalleryView multiplier:2/5.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.oneClickButton multiplier:1.1f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.oneClickButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.oneClickButton multiplier:1.0f constant:-40.0f],
                             [HHAutoLayoutUtility setViewHeight:self.oneClickButton multiplier:0 constant:80.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.stepOneButton multiplier:1.5f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.stepOneButton constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.stepOneButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewHeight:self.stepOneButton multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.stepTwoButton multiplier:1.5f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.stepTwoButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.stepTwoButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewHeight:self.stepTwoButton multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.stepThreeButton multiplier:1.5f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.stepThreeButton constant:-40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.stepThreeButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewHeight:self.stepThreeButton multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.stepOneLabel toView:self.stepOneButton constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.stepOneLabel toView:self.stepOneButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.stepTwoLabel toView:self.stepTwoButton constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.stepTwoLabel toView:self.stepTwoButton multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.stepThreeLabel toView:self.stepThreeButton constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.stepThreeLabel toView:self.stepThreeButton multiplier:1.0f constant:0],

                            ];
    [self.view addConstraints:constraints];
}

- (void)stepButtonPressed:(HHButton *)button {
    HHRootViewController *rootVC = (HHRootViewController *)self.parentViewController.parentViewController;
    if ([button isEqual:self.stepOneButton]) {
        [rootVC setSelectedIndex:TabBarItemCoachListView];
    } else if ([button isEqual:self.stepTwoButton]) {
        [rootVC setSelectedIndex:TabBarItemBookView];
    } else if ([button isEqual:self.stepThreeButton]) {
        [rootVC setSelectedIndex:TabBarItemMyReservationView];
    }
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
