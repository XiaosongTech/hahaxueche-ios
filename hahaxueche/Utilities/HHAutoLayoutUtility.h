//
//  HHAutoLayoutUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHAutoLayoutUtility : NSObject

+ (NSLayoutConstraint *)setViewWidth:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)setViewMaxWidth:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)setViewHeight:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)setViewWidthEqualToHeight:(UIView *)view;

// Multiplier should not be 0
+ (NSLayoutConstraint *)setCenterX:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
// Multiplier should not be 0
+ (NSLayoutConstraint *)setCenterY:(UIView *)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

+ (NSLayoutConstraint *)verticalAlignToSuperViewTop:(UIView *)view constant:(CGFloat)constant;
+ (NSLayoutConstraint *)verticalAlignToSuperViewBottom:(UIView *)view constant:(CGFloat)constant;
+ (NSLayoutConstraint *)verticalNext:(UIView *)view toView:(UIView *)nextToView constant:(CGFloat)constant;
+ (NSLayoutConstraint *)verticalAlignToViewBottom:(UIView *)view toView:(UIView *)toView constant:(CGFloat)constant;

+ (NSLayoutConstraint *)horizontalNext:(UIView *)view toView:(UIView *)nextToView constant:(CGFloat)constant;
+ (NSLayoutConstraint *)horizontalAlignToSuperViewLeft:(UIView *)view constant:(CGFloat)constant;
+ (NSLayoutConstraint *)horizontalAlignToSuperViewRight:(UIView *)view constant:(CGFloat)constant;

@end
