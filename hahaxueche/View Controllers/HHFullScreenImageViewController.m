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

@interface HHFullScreenImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UILabel *label;

@end

@implementation HHFullScreenImageViewController


- (instancetype)initWithImageURL:(NSURL *)imageURL title:(NSString *)title {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor blackColor];
        self.imageURL = imageURL;
        [self.imageView sd_setImageWithURL:self.imageURL placeholderImage:nil];
        
        self.label.text = title;
        [self.label sizeToFit];
        
    }
    return self;
}

- (void)dealloc {
    self.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.maximumZoomScale = 4.0f;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    [self.imageView addGestureRecognizer:tap];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    [self autoLayoutSubviews];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.scrollView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.imageView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.label multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.label constant:-20.0f],
                             ];
    [self.view addConstraints:constraints];
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
