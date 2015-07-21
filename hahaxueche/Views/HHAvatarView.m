//
//  HHAvatarView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAvatarView.h"
#import "HHAutoLayoutUtility.h"

#define kBorderWidth 1.0f

@implementation HHAvatarView

- (instancetype)initWithImage:(UIImage *)image radius:(CGFloat)radius borderColor:(UIColor *)borderColor {
    self = [super init];
    if (self) {
        self.backgroundColor = borderColor;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.radius = radius;
        self.layer.cornerRadius = radius;
        self.imageView.layer.cornerRadius = radius-kBorderWidth;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = image;
        [self addSubview:self.imageView];
        [self autolayoutSubviews];
    }
    return self;
}

- (void)autolayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.imageView constant:kBorderWidth],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.imageView constant:kBorderWidth],
                             [HHAutoLayoutUtility setViewWidth:self.imageView multiplier:1.0f constant:-kBorderWidth*2],
                             [HHAutoLayoutUtility setViewHeight:self.imageView multiplier:1.0f constant:-kBorderWidth*2],
                             ];
    [self addConstraints:constraints];
}

@end
