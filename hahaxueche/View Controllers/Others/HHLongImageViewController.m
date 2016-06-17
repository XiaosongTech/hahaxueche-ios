//
//  HHLongImageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/29/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHLongImageViewController.h"
#import "UIImage+HHImage.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHLongImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation HHLongImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学员常见问题";
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    
    self.imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.imageView];
    
    if (self.image) {
        UIImage *scaledImage = [UIImage imageWithImage:self.image scaledToWidth:CGRectGetWidth(self.view.bounds)];
        self.imageView.image = scaledImage;
        self.imageView.frame = CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height);
        self.scrollView.contentSize = scaledImage.size;
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
