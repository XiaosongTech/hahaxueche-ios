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
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollView.bounces = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        [self addImageViews];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.scrollView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewMaxWidth:self.scrollView multiplier:1.0f constant:0],
                             
                             ];
    [self addConstraints:constraints];
}

-(void)addImageViews {
    for (int i = 0; i < self.URLStrings.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.URLStrings[i]] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
        NSArray *constraints = @[
                                 [HHAutoLayoutUtility setCenterX:imageView multiplier:1.0f+2*i constant:0],
                                 [HHAutoLayoutUtility setCenterY:imageView multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:imageView multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewMaxWidth:imageView multiplier:1.0f constant:0],
                                 
                                 ];
        [self addConstraints:constraints];
        
        if (i == self.URLStrings.count - 1) {
            // Let scrollView know the contentSize
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:0]];
            
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0]];
        }
    }
    
}

@end
