//
//  HHPopupUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLCPopup.h"

@interface HHPopupUtility : NSObject

+ (KLCPopup *)createPopupWithContentView:(UIView *)contentView;

+ (KLCPopup *)createPopupWithContentView:(UIView *)contentView showType:(KLCPopupShowType)showType dismissType:(KLCPopupDismissType)dismissType;

+ (void)showPopup:(KLCPopup *)popup;

+ (void)showPopup:(KLCPopup *)popup layout:(KLCPopupLayout)layout;

+ (void)showPopup:(KLCPopup *)popup AtCenter:(CGPoint)center inView:(UIView *)view;

+ (void)dismissPopup:(KLCPopup *)popup;

@end
