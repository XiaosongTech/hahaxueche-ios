//
//  HHPopupUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPopupUtility.h"

@implementation HHPopupUtility

+ (void)showPopupWithContentView:(UIView *)contentView {
    [[KLCPopup popupWithContentView:contentView
                          showType:KLCPopupShowTypeGrowIn
                       dismissType:KLCPopupDismissTypeGrowOut
                          maskType:KLCPopupMaskTypeDimmed
          dismissOnBackgroundTouch:YES
              dismissOnContentTouch:NO] show];
    
}

@end
