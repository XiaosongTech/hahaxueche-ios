//
//  HHScrollImageGallery.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScrollImageGallery.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HHScrollImageGallery

- (instancetype)initWithURLStrings:(NSArray *)URLStrings {
    self = [super init];
    if (self) {
        self.URLStrings = URLStrings;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.images = images;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.imageViews = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImageView)];
    [self.scrollView addGestureRecognizer:tap];
    [self addSubview:self.scrollView];
    [self addImageViews];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    if ([self.URLStrings count]) {
       self.pageControl.numberOfPages = self.URLStrings.count;
    } else {
        self.pageControl.numberOfPages = self.images.count;
    }
    
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor HHOrange];
    [self addSubview:self.pageControl];

}

-(void)showFullImageView {
    [self.delegate showFullImageView:self.pageControl.currentPage];
}

- (void)changePage {
    CGFloat x = self.pageControl.currentPage * CGRectGetWidth(self.scrollView.bounds);
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(void)addImageViews {
    if ([self.URLStrings count]) {
        for (int i = 0; i < self.URLStrings.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLStrings[i]] placeholderImage:nil];
            [self.scrollView addSubview:imageView];
            [self.imageViews addObject:imageView];
        }

    } else {
        for (int i = 0; i < self.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = self.images[i] ;
            [self.scrollView addSubview:imageView];
            [self.imageViews addObject:imageView];
        }
    }
    
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    NSArray *trueImagesArray = self.URLStrings;
    if ([self.images count]) {
        trueImagesArray = self.images;
    }
    for (int i = 0; i < trueImagesArray.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageView.frame = CGRectMake(i * CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [imageView layoutIfNeeded];
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * trueImagesArray.count, CGRectGetHeight(self.scrollView.bounds));
    
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 25.0f, CGRectGetWidth(self.bounds), 25.0f);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageNumber = roundf(self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds));
    self.pageControl.currentPage = pageNumber;
}

@end
