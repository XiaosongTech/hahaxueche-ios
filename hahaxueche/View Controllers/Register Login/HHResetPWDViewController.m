//
//  HHResetPWDViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHResetPWDViewController.h"
#import "HHPhoneNumberUtility.h"
#import "HHToastManager.h"
#import "HHLoadingViewUtility.h"
#import "HHUserAuthService.h"
#import "UIColor+HHColor.h"

@implementation HHResetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码重置";
    
}
- (void)verifyPhoneNumber {
    if ([[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.phoneNumberField.textField.text]) {
        __weak HHRegisterViewController *weakSelf = self;
        [self sendCodeWithCompletion:^{
            [weakSelf showMoreFields];
            [weakSelf.phoneNumberField.textField resignFirstResponder];
            [weakSelf.verificationCodeField.textField becomeFirstResponder];
        }];
    } else {
        [[HHToastManager sharedManager] showErrorToastWithText:@"手机号无效，请仔细核对！"];
    }
}

- (void)sendCodeWithCompletion:(HHGenericCompletion)completion {
    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"验证码发送中"];
    [[HHUserAuthService sharedInstance] sendVeriCodeToNumber:self.phoneNumberField.textField.text type:@"login" completion:^(NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
            [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
            [self.sendCodeButton setTitleColor:[UIColor HHLightOrange] forState:UIControlStateNormal];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.timer) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
                }
            });
            
            self.sendCodeButton.enabled = NO;
            if (completion) {
                completion();
            }
        } else {
            //if the cell phone has already registerd, lead the user to login view
            if ([error.localizedFailureReason isEqual:@(40044)]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"该手机号还未注册，请先注册！"];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"发送失败，请重试！"];
            }
        }
    }];
}
- (void)doneButtonTapped {
    
    if (![self areAllFieldsValid]) {
        return;
    }
    
    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"密码重置中"];
    [[HHUserAuthService sharedInstance] resetPWDWithCellphone:self.phoneNumberField.textField.text veriCode:self.verificationCodeField.textField.text newPWD:self.pwdField.textField.text completion:^(NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            [[HHToastManager sharedManager] showSuccessToastWithText:@"密码重置成功，请登陆！"];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"密码重置失败，请重试！"];
        }
    }];

}



@end
