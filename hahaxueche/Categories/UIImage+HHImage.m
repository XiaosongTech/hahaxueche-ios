//
//  UIImage+HHImage.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "UIImage+HHImage.h"
#import "UIImage+ImageEffects.h"

@implementation UIImage (HHImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (CGFloat) i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), YES, [UIScreen mainScreen].scale);
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)blur:(UIImage *)theImage {
    
    return [theImage applyExtraLightEffect];
}

@end
