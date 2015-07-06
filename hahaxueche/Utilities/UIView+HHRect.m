//
//  UIView+HHRect.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "UIView+HHRect.h"

@implementation UIView (HHRect)

- (void)setFrameWithOrigin:(CGPoint)origin {
    CGRect newRect = self.frame;
    
    newRect.origin = origin;
    
    self.frame = newRect;
}

- (void)setFrameWithSize:(CGSize)size {
    CGRect newRect = self.frame;
    
    newRect.size = size;
    
    self.frame = newRect;
}

- (void)setFrameWithWidth:(CGFloat)width {
    CGRect newRect = self.frame;
    
    newRect.size.width = width;
    
    self.frame = newRect;
}

- (void)setFrameWithHeight:(CGFloat)height {
    CGRect newRect = self.frame;
    
    newRect.size.height = height;
    
    self.frame = newRect;
}

- (void)setFrameWithX:(CGFloat)x {
    CGRect newRect = self.frame;
    
    newRect.origin.x = x;
    
    self.frame = newRect;
}

- (void)setFrameWithY:(CGFloat)y {
    CGRect newRect = self.frame;
    
    newRect.origin.y = y;
    
    self.frame = newRect;
}



@end
