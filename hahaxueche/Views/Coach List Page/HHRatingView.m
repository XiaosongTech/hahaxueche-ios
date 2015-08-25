//
//  HHRatingView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/11/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHRatingView.h"

#define kCarTotalAmount 5

@interface HHRatingView ()

@property (nonatomic, strong) NSMutableArray *starViews;

@end

@implementation HHRatingView

- (instancetype)initWithInteractionEnabled:(BOOL)enabled {
    self = [super init];
    if (self) {
        self.interactionEnabled = enabled;
        self.starViews = [NSMutableArray array];
    }
    return self;
}

- (void)setupViewWithRating:(CGFloat)ratingValue {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.rating = ratingValue;
    for (int i = 0; i < kCarTotalAmount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*17.0f, 0, 15.0f, 15.0f)];
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carPressed:)];
        [imageView addGestureRecognizer:recognizer];
        [self.starViews addObject:imageView];
        [self addSubview:imageView];
        if (ratingValue - i >= 1 ) {
            imageView.image = [UIImage imageNamed:@"star_full"];
        } else if (ratingValue - i > 0 && ratingValue - i < 1){
            imageView.image = [UIImage imageNamed:@"star_half"];
        } else {
            imageView.image = [UIImage imageNamed:@"star_empty"];
        }
    }
}

- (void)carPressed:(UITapGestureRecognizer *)sender {
    if (!self.interactionEnabled) {
        return;
    }
    UIImageView *tappedImageView = (UIImageView *)sender.view;
    for (int i = 0; i < kCarTotalAmount; i++) {
        UIImageView *imageView = self.starViews[i];
        if (tappedImageView.tag - 1 >= i ) {
            imageView.image = [UIImage imageNamed:@"star_full"];
        } else {
            imageView.image = [UIImage imageNamed:@"star_empty"];
        }
    }
    
    self.rating = tappedImageView.tag;
}

@end
