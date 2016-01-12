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

+ (void)showPopup:(KLCPopup *)popup;

+ (void)dismissPopup:(KLCPopup *)popup;

@end
