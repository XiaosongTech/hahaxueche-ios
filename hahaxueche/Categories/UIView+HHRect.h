//
//  UIView+HHRect.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HHRect)

- (void)setFrameWithOrigin:(CGPoint)origin;
- (void)setFrameWithSize:(CGSize)size;
- (void)setFrameWithWidth:(CGFloat)width;
- (void)setFrameWithHeight:(CGFloat)height;
- (void)setFrameWithX:(CGFloat)x;
- (void)setFrameWithY:(CGFloat)y;


@end
