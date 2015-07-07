//
//  HHBarButtonItemUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHBarButtonItemUtility.h"

@implementation HHBarButtonItemUtility

+ (UIBarButtonItem *)buttonItemWithImage:(UIImage *)image action:(SEL)action{
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
     return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
