//
//  UIImage+HHImage.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HHImage)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(CGFloat) i_width;

@end
