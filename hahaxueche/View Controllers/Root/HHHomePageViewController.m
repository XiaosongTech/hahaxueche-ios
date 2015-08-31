//
//  HHHomePageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHHomePageViewController.h"
#import "HHAutoLayoutUtility.h"
#import "HHButton.h"
#import "UIColor+HHColor.h"
#import "HHRootViewController.h"
#import "HHFullScreenImageViewController.h"
#import "HHScrollImageGallery.h"
#import "HHTrainingFieldService.h"
#import "HHCoachProfileViewController.h"
#import "HHCoachService.h"
#import "HHLoadingView.h"
#import "HHToastUtility.h"

@interface HHHomePageViewController () <HHScrollImageGalleryDelegate>

@property (nonatomic, strong) HHScrollImageGallery *imageGalleryView;
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

-(void)dealloc {
    self.imageGalleryView.delegate = nil;
}

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"哈哈学车",nil);
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imagesArray = @[@"http://ac-cr9pv6bp.clouddn.com/wiB2E9Rplx5UDHpH8gYJFYC", @"http://ac-cr9pv6bp.clouddn.com/wiB2E9Rplx5UDHpH8gYJFYC"];
    self.imageGalleryView = [[HHScrollImageGallery alloc] initWithURLStrings:self.imagesArray];
    self.imageGalleryView.delegate = self;
    self.imageGalleryView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200.0f);
    [self.view addSubview:self.imageGalleryView];
    
    self.oneClickButton = [[HHButton alloc] initSolidButtonWithTitle:NSLocalizedString(@"一 键 找 教 练",nil) textColor:[UIColor whiteColor] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:30.0f]];
    [self.oneClickButton addTarget:self action:@selector(findCoach) forControlEvents:UIControlEventTouchUpInside];
    self.oneClickButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.oneClickButton];
    
    self.stepOneButton = [self createButtonWithTitle:@"1"];
    self.stepTwoButton = [self createButtonWithTitle:@"2"];
    self.stepThreeButton = [self createButtonWithTitle:@"3"];
    
    self.stepOneLabel = [self createLabelWithTitle:NSLocalizedString(@"选择教练",nil) textColor:[UIColor blackColor] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:12]];
    
    self.stepTwoLabel = [self createLabelWithTitle:NSLocalizedString(@"预约练车",nil) textColor:[UIColor blackColor] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:12]];
    
    self.stepThreeLabel = [self createLabelWithTitle:NSLocalizedString(@"查看预约",nil) textColor:[UIColor blackColor] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:12]];
    
    [self autoLayoutSubviews];
}

- (HHButton *)createButtonWithTitle:(NSString *)title {
    HHButton *button = [[HHButton alloc] initThinBorderButtonWithTitle:title textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:20.0f] borderColor:[UIColor HHOrange] backgroundColor:[UIColor clearColor]];
    button.layer.cornerRadius = 20.0f;
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

- (void)findCoach {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:@"寻找教练中"];
    [[HHCoachService sharedInstance] recommendCoachWithCompletion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if ([objects count]) {
            int randomIndex = arc4random() % objects.count;
            HHCoach *recommendCoach = objects[randomIndex];
            HHCoachProfileViewController *coachVC = [[HHCoachProfileViewController alloc] initWithCoach:recommendCoach];
            [self.navigationController pushViewController:coachVC animated:YES];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"抱歉，没有找到合适到教练", nil) isError:YES];
        }
       
    }];
}

#pragma -mark HHScrollImageGallery Delegate

- (void)showFullImageView:(NSInteger)index {
    HHFullScreenImageViewController *fullImageVC = [[HHFullScreenImageViewController alloc] initWithImageURL:[NSURL URLWithString:self.imagesArray[index] ] title:nil];
    [self.tabBarController presentViewController:fullImageVC animated:YES completion:nil];
}

@end
