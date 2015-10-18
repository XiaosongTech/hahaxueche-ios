//
//  HHFullScreenImageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHFullScreenImageViewController.h"
#import "HHAutoLayoutUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHLoadingView.h"
#import "UIView+HHRect.h"

@interface HHFullScreenImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *subScrollViews;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) NSInteger initialIndex;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation HHFullScreenImageViewController


- (instancetype)initWithImageURLArray:(NSArray *)imageURLArray titleArray:(NSArray *)titleArray initalIndex:(NSInteger)initialIndex{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.imageURLs = imageURLArray;
        self.titles = titleArray;
        self.initialIndex = initialIndex;
        self.currentIndex = initialIndex;
    }
    return self;
}

- (void)dealloc {
    self.scrollView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * CGRectGetWidth(self.scrollView.bounds), 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.imageViews = [NSMutableArray array];
    self.subScrollViews = [NSMutableArray array];
    
    self.indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.indexLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.text = [self generateIndexString];
    
    [self.view addSubview:self.indexLabel];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.label.textColor = [UIColor whiteColor];
    if ([self.titles count]) {
        self.label.text = self.titles[self.initialIndex];
    }
    [self.view addSubview:self.label];
    
    
    for (int i = 0; i < self.imageURLs.count; i++) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        scrollView.delegate = self;
        scrollView.userInteractionEnabled = YES;
        scrollView.maximumZoomScale = 4.0f;
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollEnabled = YES;
        [self.scrollView addSubview:scrollView];
        [self.subScrollViews addObject:scrollView];

        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
        [imageView addGestureRecognizer:tap];
        [self.imageViews addObject:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[i]] placeholderImage:nil];

    }
    
    
    [self autoLayoutSubviews];}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.indexLabel constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.indexLabel constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.indexLabel multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.indexLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.scrollView toView:self.indexLabel constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.scrollView constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.scrollView constant:-20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.scrollView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.label toView:self.scrollView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.label constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.label constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.label multiplier:1.0f constant:0],
                             
                             ];
    [self.view addConstraints:constraints];
    
    
    for (int i = 0; i < self.imageURLs.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        UIScrollView *scrollView = self.subScrollViews[i];
        NSArray *constraints = @[
                                 
                                 [HHAutoLayoutUtility setCenterX:scrollView multiplier:(1.0f + i * 2.0f) constant:0],
                                 [HHAutoLayoutUtility setCenterY:scrollView multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:scrollView multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:scrollView multiplier:1.0f constant:0],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewTop:imageView constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:imageView constant:0],
                                 [HHAutoLayoutUtility setViewHeight:imageView multiplier:1.0f constant:-20.0f],
                                 [HHAutoLayoutUtility setViewWidth:imageView multiplier:1.0f constant:0],
                                 
                                 ];
        [self.view addConstraints:constraints];

    }
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:[self.subScrollViews lastObject]
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:[self.subScrollViews lastObject]
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0]];
    

}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageViews[self.currentIndex];
}

- (NSString *)generateIndexString {
    if (self.imageURLs.count <= 1) {
        return @"";
    }
    return  [NSString stringWithFormat:@"%ld/%lu", (long)self.currentIndex + 1, (unsigned long)self.imageURLs.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = roundf(self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds));
    self.indexLabel.text = [self generateIndexString];
    if ([self.titles count]) {
        self.label.text = self.titles[self.currentIndex];
    }
    
}





@end
