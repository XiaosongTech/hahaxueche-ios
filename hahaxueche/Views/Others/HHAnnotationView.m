//
//  HHAnnotationView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHAnnotationView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHPointAnnotation.h"

@implementation HHAnnotationView


- (UIView *)leftCalloutAccessoryView {
    HHPointAnnotation *annotation = self.annotation;
    HHCalloutView *view = [[HHCalloutView alloc] initWithField:annotation.field];
    self.calloutView = view;
    return view;
}

- (UIView *)rightCalloutAccessoryView {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}


@end
