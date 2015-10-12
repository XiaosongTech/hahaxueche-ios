//
//  HHStartAppLoadingViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/14/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHStartAppLoadingViewController.h"
#import "HHAutoLayoutUtility.h"

@interface HHStartAppLoadingViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation HHStartAppLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.image = [UIImage imageNamed:@"splash"];
    [self.view addSubview:self.imageView];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.imageView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.spinner multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.spinner multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.spinner multiplier:0 constant:60.0f],
                             [HHAutoLayoutUtility setViewWidth:self.spinner multiplier:0 constant:60.0f],
                             ];
    [self.view addConstraints:constraints];
}





@end
