//
//  HHRatingView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/11/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHRatingView : UIView

@property (nonatomic) BOOL interactionEnabled;
@property (nonatomic) CGFloat rating;

- (instancetype)initWithInteractionEnabled:(BOOL)enabled;
- (void)setupViewWithRating:(CGFloat)ratingValue;

@end
