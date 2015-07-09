//
//  UIBarButtonItem+HHCustomButton.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "UIBarButtonItem+HHCustomButton.h"

@implementation UIBarButtonItem (HHCustomButton)

+ (UIBarButtonItem *)buttonItemWithImage:(UIImage *)image action:(SEL)action target:(id)target {
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, -10.0f)];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)title action:(SEL)action target:(id)target {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Normal" size:13];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, -10.0f)];
    return [[UIBarButtonItem alloc] initWithCustomView:button];;
}


@end
