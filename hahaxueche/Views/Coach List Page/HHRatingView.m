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

@property (nonatomic, strong) NSMutableArray *cars;

@end

@implementation HHRatingView

- (instancetype)initWithFloat:(CGFloat)ratingValue interactionEnabled:(BOOL)enabled {
    self = [super init];
    if (self) {
        self.ratingValue = ratingValue;
        self.interactionEnabled = enabled;
        
        for (int i = 0; i < kCarTotalAmount; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*22.0f, 0, 19.0f, 15.0f)];
            imageView.tag = i+1;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carPressed:)];
            [imageView addGestureRecognizer:recognizer];
            [self.cars addObject:imageView];
            [self addSubview:imageView];
            if (ratingValue - i >= 1 ) {
                imageView.image = [UIImage imageNamed:@"ratingcar_solid"];
            } else if (ratingValue - i > 0 && ratingValue - i < 1){
                imageView.image = [UIImage imageNamed:@"ratingcar_half"];
            } else {
                imageView.image = [UIImage imageNamed:@"ratingcar_line"];
            }
        }
    
    }
    return self;
}

- (void)carPressed:(id)sender {
    if (!self.interactionEnabled) {
        return;
    }
    UIImageView *imageView = sender;
    for (int i = 0; i < kCarTotalAmount; i++) {
        if (imageView.tag - i >= 1 ) {
            imageView.image = [UIImage imageNamed:@"ratingcar_solid"];
        } else {
            imageView.image = [UIImage imageNamed:@"ratingcar_line"];
        }

    }
}

@end
