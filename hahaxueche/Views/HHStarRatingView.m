//
//  HHStarRatingView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHStarRatingView.h"

@implementation HHStarRatingView

- (instancetype)initWithInteraction:(BOOL)allowInteraction {
    self = [super init];
    if (self) {
        self.minimumValue = 0;
        self.maximumValue = 5.0f;
        self.emptyStarImage = [UIImage imageNamed:@"ic_Star_grey"];
        self.halfStarImage = [UIImage imageNamed:@"ic_Star_half"];
        self.filledStarImage = [UIImage imageNamed:@"ic_Star_light"];
        self.accurateHalfStars = NO;
        self.allowsHalfStars = YES;
        self.userInteractionEnabled = allowInteraction;
    }
    
    return self;
}

@end
