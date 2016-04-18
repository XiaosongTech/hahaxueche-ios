//
//  HHToastManager.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHToastManager.h"
#import <CRToast/CRToast.h>
#import "UIColor+HHColor.h"

@implementation HHToastManager

+ (HHToastManager *)sharedManager {
    static HHToastManager *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHToastManager alloc] init];
    });
    
    return manager;
}

- (void)showErrorToastWithText:(NSString *)text {
    NSMutableDictionary *options = [self buildBasicOptions];
    options[kCRToastTextKey] = text;
    options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:1 green:0.45 blue:0.01 alpha:1];
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
    
}

- (void)showSuccessToastWithText:(NSString *)text {
    NSMutableDictionary *options = [self buildBasicOptions];
    options[kCRToastTextKey] = text;
    options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:0.47 green:0.87 blue:0.01 alpha:1];
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
}

- (NSMutableDictionary *)buildBasicOptions {
    NSDictionary *options = @{
                              kCRToastNotificationPreferredPaddingKey : @(-15.0f),
                              kCRToastTextColorKey: [UIColor whiteColor],
                              kCRToastFontKey : [UIFont systemFontOfSize:15.0f],
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationPresentationTypeKey  : @(CRToastPresentationTypeCover),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastTimeIntervalKey : @(3),
                              kCRToastImageAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastInteractionRespondersKey :@[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                  automaticallyDismiss:YES
                                                                                                                                 block:^(CRToastInteractionType interactionType){
                                                                                                                                     NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                                                                                 }]]
                              };
    return [NSMutableDictionary dictionaryWithDictionary:options];

}

@end
