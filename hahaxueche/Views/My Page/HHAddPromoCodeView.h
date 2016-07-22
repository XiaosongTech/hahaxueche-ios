//
//  HHAddPromoCodeView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHPromoCodeViewConfrimBlock)(NSString *promoCode);
typedef void (^HHPromoCodeViewCancelBlock)();

@interface HHAddPromoCodeView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UITextField *promoCodeField;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

@property (nonatomic, strong) HHPromoCodeViewConfrimBlock confirmBlock;
@property (nonatomic, strong) HHPromoCodeViewCancelBlock cancelBlock;


@end
