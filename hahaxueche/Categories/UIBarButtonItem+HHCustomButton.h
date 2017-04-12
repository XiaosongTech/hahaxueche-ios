//
//  UIBarButtonItem+HHCustomButton.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HHCustomButton)

+ (UIBarButtonItem *)buttonItemWithImage:(UIImage *)image action:(SEL)action target:(id)target;

+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor action:(SEL)action target:(id)target isLeft:(BOOL)isLeft;

+ (UIBarButtonItem *)buttonItemWithAttrTitle:(NSAttributedString *)attrTitle action:(SEL)action target:(id)target isLeft:(BOOL)isLeft;


@end
