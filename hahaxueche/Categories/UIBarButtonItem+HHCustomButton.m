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
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)title action:(SEL)action target:(id)target isLeft:(BOOL)isLeft {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Normal" size:15];
    if (isLeft) {
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, -10.0f, 0, 10.0f)];
    } else {
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, -10.0f)];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
