//
//  UIColor+HHColor.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "UIColor+HHColor.h"

@implementation UIColor (HHColor)

+ (UIColor *)HHOrange {
    return [UIColor colorWithRed:0.88 green:0.48 blue:0.13 alpha:1];
}

+ (UIColor *)HHLightOrange {
    return [UIColor colorWithRed:1 green:0.69 blue:0.25 alpha:1];
}

+ (UIColor *)HHTransparentWhite {
    return [UIColor colorWithWhite:1.0f alpha:0.3f];
}

+ (UIColor *)HHLightGrayBackgroundColor {
    return [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
}

+ (UIColor *)HHGrayTextColor {
    return [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
}

+ (UIColor *)HHGrayLineColor {
    return [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
}

+ (UIColor *)HHTransparentOrange {
    return [UIColor colorWithRed:0.88 green:0.48 blue:0.13 alpha:0.8f];
}

@end
