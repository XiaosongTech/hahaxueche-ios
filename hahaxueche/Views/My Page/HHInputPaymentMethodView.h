//
//  HHInputPaymentMethodView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/29/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"
#import "HHGenericTwoButtonsPopupView.h"

typedef void (^HHInputAliPayConfirmBlock)(NSString *account, NSString *ownerName);

@interface HHInputPaymentMethodView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *ownerNameField;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UIView *secondLine;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

@property (nonatomic, strong) HHInputAliPayConfirmBlock confirmBlock;
@property (nonatomic, strong) HHPopupBlock cancelBlock;

@end
