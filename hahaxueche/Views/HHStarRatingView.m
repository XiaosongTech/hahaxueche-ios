//
//  HHStarRatingView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStarRatingView.h"

@implementation HHStarRatingView

- (instancetype)initWithFrame:(CGRect)frame rating:(CGFloat)rating {
    self = [super initWithFrame:frame];
    if (self) {
        self.value = rating;
        self.maximumValue = 5.0f;
        self.minimumValue = 0;
        self.allowsHalfStars = YES;
        self.emptyStarImage = [UIImage imageNamed:@"star_empty"];
        self.filledStarImage = [UIImage imageNamed:@"star_full"];
        self.halfStarImage = [UIImage imageNamed:@"star_half"];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end
