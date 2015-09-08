//
//  HHToastUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHToastUtility.h"
#import "CRToast.h"

#define kGreenColor [UIColor colorWithRed:0.36 green:0.75 blue:0.36 alpha:1]
#define kRedColor [UIColor colorWithRed:0.93 green:0.25 blue:0.22 alpha:1]

@implementation HHToastUtility

+ (void)showToastWitiTitle:(NSString *)title isError:(BOOL)isError {
    UIColor *backgroundColor = kGreenColor;
    if (isError) {
        backgroundColor = kRedColor;
    }
    NSDictionary *options = @{

                              kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey:@(CRToastPresentationTypeCover),
                              kCRToastTextKey: title,
                              kCRToastFontKey: [UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f],
                              kCRToastTextAlignmentKey: @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey: backgroundColor,
                              kCRToastAnimationInTypeKey: @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey: @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey: @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey: @(CRToastAnimationDirectionBottom),
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
}

+ (void)showToastWitiTitle:(NSString *)title timeInterval:(NSNumber *)interval isError:(BOOL)isError {
    UIColor *backgroundColor = kGreenColor;
    if (isError) {
        backgroundColor = kRedColor;
    }
    NSDictionary *options = @{
                              
                              kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey:@(CRToastPresentationTypeCover),
                              kCRToastTextKey: title,
                              kCRToastFontKey: [UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f],
                              kCRToastTextAlignmentKey: @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey: backgroundColor,
                              kCRToastAnimationInTypeKey: @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey: @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey: @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey: @(CRToastAnimationDirectionBottom),
                              kCRToastTimeIntervalKey: interval,
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];

}

@end
