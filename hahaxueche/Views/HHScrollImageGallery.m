//
//  HHScrollImageGallery.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScrollImageGallery.h"
#import "HHAutoLayoutUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HHScrollImageGallery

- (instancetype)initWithURLStrings:(NSArray *)URLStrings {
    self = [super init];
    if (self) {
        self.URLStrings = URLStrings;
        self.imageViews = [NSMutableArray array];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.bounces = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        [self addImageViews];
    }
    return self;
}

-(void)addImageViews {
    for (int i = 0; i < self.URLStrings.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLStrings[i]] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
    
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    for (int i = 0; i < self.URLStrings.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageView.frame = CGRectMake(i * CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [imageView layoutIfNeeded];
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * self.URLStrings.count, CGRectGetHeight(self.scrollView.bounds));
}

@end
