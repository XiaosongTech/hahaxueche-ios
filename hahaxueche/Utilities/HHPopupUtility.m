//
//  HHPopupUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPopupUtility.h"

@implementation HHPopupUtility

+ (KLCPopup *)createPopupWithContentView:(UIView *)contentView showType:(KLCPopupShowType)showType dismissType:(KLCPopupDismissType)dismissType {
    return [KLCPopup popupWithContentView:contentView
                                 showType:showType
                              dismissType:dismissType
                                 maskType:KLCPopupMaskTypeDimmed
                 dismissOnBackgroundTouch:YES
                    dismissOnContentTouch:NO];
}

+ (KLCPopup *)createPopupWithContentView:(UIView *)contentView {
    
    return [HHPopupUtility createPopupWithContentView:contentView showType:KLCPopupShowTypeSlideInFromTop dismissType:KLCPopupDismissTypeSlideOutToTop];
}

+ (void)dismissPopup:(KLCPopup *)popup {
    [popup dismiss:YES];
}

+ (void)showPopup:(KLCPopup *)popup {
    [HHPopupUtility showPopup:popup layout:KLCPopupLayoutCenter];
}

+ (void)showPopup:(KLCPopup *)popup layout:(KLCPopupLayout)layout {
    [popup showWithLayout:layout];
}

+ (void)showPopup:(KLCPopup *)popup AtCenter:(CGPoint)center inView:(UIView *)view {
    [popup showAtCenter:center inView:view];
}

@end
