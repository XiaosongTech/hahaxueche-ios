//
//  HHRegisterViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHButton.h"
#import "HHTextFieldView.h"

typedef void (^HHGenericCompletion)();

@interface HHRegisterViewController : UIViewController

@property (nonatomic, strong) HHButton *nextButton;
@property (nonatomic, strong) HHTextFieldView *phoneNumberField;
@property (nonatomic, strong) HHTextFieldView *verificationCodeField;
@property (nonatomic, strong) HHTextFieldView *pwdField;
@property (nonatomic, strong) HHGenericCompletion jumpToLoginViewBlock;

- (void)doneButtonTapped;

@end
