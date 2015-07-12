//
//  HHRatingView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/11/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHRatingView : UIView

@property (nonatomic)   CGFloat ratingValue;
@property (nonatomic)   BOOL    interactionEnabled;

- (instancetype)initWithFloat:(CGFloat)ratingValue interactionEnabled:(BOOL)enabled;

@end
