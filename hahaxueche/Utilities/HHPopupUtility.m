//
//  HHPopupUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPopupUtility.h"

@implementation HHPopupUtility

+ (KLCPopup *)createPopupWithContentView:(UIView *)contentView {
    return [KLCPopup popupWithContentView:contentView
                          showType:KLCPopupShowTypeGrowIn
                       dismissType:KLCPopupDismissTypeGrowOut
                          maskType:KLCPopupMaskTypeDimmed
          dismissOnBackgroundTouch:YES
              dismissOnContentTouch:NO];
}

+ (void)dismissPopup:(KLCPopup *)popup {
    [popup dismiss:YES];
}

+ (void)showPopup:(KLCPopup *)popup {
    [popup show];
}

@end
