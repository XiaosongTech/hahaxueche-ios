//
//  HHAutoLayoutUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHAutoLayoutUtility.h"

@implementation HHAutoLayoutUtility

+ (NSLayoutConstraint *)setViewWidth:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeWidth
            multiplier:multiplier
            constant:constant];
}

+ (NSLayoutConstraint *)setViewHeight:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeHeight
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeHeight
            multiplier:multiplier
            constant:constant];
}

+ (NSLayoutConstraint *)setCenterX:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeCenterX
            multiplier:multiplier
            constant:constant];
}

+ (NSLayoutConstraint *)setCenterY:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeCenterY
            multiplier:multiplier
            constant:constant];
}

+ (NSLayoutConstraint *)setViewWidthEqualToHeight:(UIView *)view {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationEqual
            toItem:view
            attribute:NSLayoutAttributeHeight
            multiplier:1
            constant:0.0];
}

+ (NSLayoutConstraint *)verticalNext:(UIView *)view toView:(UIView *)nextToView constant:(CGFloat)constant{
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeTop
            relatedBy:NSLayoutRelationEqual
            toItem:nextToView
            attribute:NSLayoutAttributeBottom
            multiplier:1
            constant:constant];
}

+ (NSLayoutConstraint *)horizontalNext:(UIView *)view toView:(UIView *)nextToView constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeLeft
            relatedBy:NSLayoutRelationEqual
            toItem:nextToView
            attribute:NSLayoutAttributeRight
            multiplier:1
            constant:constant];
}

+ (NSLayoutConstraint *)verticalAlignToSuperViewTop:(UIView *)view constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeTop
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeTop
            multiplier:1
            constant:constant];
}

+ (NSLayoutConstraint *)verticalAlignToSuperViewBottom:(UIView *)view constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeBottom
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeBottom
            multiplier:1
            constant:constant];
}


+ (NSLayoutConstraint *)horizontalAlignToSuperViewLeft:(UIView *)view constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeLeading
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeLeading
            multiplier:1
            constant:constant];
}

+ (NSLayoutConstraint *)horizontalAlignToSuperViewRight:(UIView *)view constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeTrailing
            relatedBy:NSLayoutRelationEqual
            toItem:view.superview
            attribute:NSLayoutAttributeTrailing
            multiplier:1
            constant:constant];
}

+ (NSLayoutConstraint *)verticalAlignToViewBottom:(UIView *)view toView:(UIView *)toView constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeBottom
            relatedBy:NSLayoutRelationEqual
            toItem:toView
            attribute:NSLayoutAttributeBottom
            multiplier:1
            constant:constant];
    
}

+ (NSLayoutConstraint *)setViewMaxWidth:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint
            constraintWithItem:view
            attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationLessThanOrEqual
            toItem:view.superview
            attribute:NSLayoutAttributeWidth
            multiplier:multiplier
            constant:constant];
    
}


@end
