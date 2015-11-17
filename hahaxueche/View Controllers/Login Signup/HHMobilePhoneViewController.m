//
//  HHMobilePhoneViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMobilePhoneViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHTextFieldView.h"
#import "NBPhoneNumberUtil.h"
#import "HHButton.h"
#import "UIView+HHRect.h"
#import "HHProfileSetupViewController.h"
#import "HHRootViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"
#import "HHLoadingView.h"
#import "HHUser.h"
#import <SMS_SDK/SMSSDK.h>
#import "HHEventTrackingManager.h"


@interface HHMobilePhoneViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) HHTextFieldView *numberFieldView;
@property (nonatomic, strong) NBPhoneNumberUtil *numberUtil;
@property (nonatomic, strong) HHButton *sendCodeButton;
@property (nonatomic, strong) HHButton *verifyCodeButton;
@property (nonatomic, strong) HHTextFieldView *verificationCodeFieldView;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *subTitleText;
@property (nonatomic)         PageType type;
@property (nonatomic, strong) HHUser *user;



@end

@implementation HHMobilePhoneViewController

- (instancetype)initWithType:(PageType)type {
    self = [super init];
    if (self) {
        self.numberUtil = [[NBPhoneNumberUtil alloc] init];
        self.type = type;
        if(self.type == PageTypeSignup) {
            self.title = NSLocalizedString(@"手机验证",nil);
            self.titleText = NSLocalizedString(@"请输入您的手机号码",nil);
            self.subTitleText = NSLocalizedString(@"我们会保护好您的个人信息",nil);
        } else {
            self.title = NSLocalizedString(@"手机号登陆",nil);
        }
        self.view.backgroundColor = [UIColor HHOrange];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    if (self.type == PageTypeSignup) {
        self.titleLabel = [self createLabelWithTitle:self.titleText font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.0f] textColor:[UIColor whiteColor]];
        self.subTitleLabel = [self createLabelWithTitle:self.subTitleText font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    }
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"取消",nil) action:@selector(cancel) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.numberFieldView = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"手机号码",nil)];
    self.numberFieldView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.numberFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.numberFieldView];
    
    self.sendCodeButton = [[HHButton alloc] initThinBorderButtonWithTitle:NSLocalizedString(@"发送验证码",nil) textColor:[UIColor whiteColor]font:[UIFont fontWithName:@"STHeitiSC-Medium" size:10.0f] borderColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    [self.sendCodeButton addTarget:self action:@selector(sendSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.sendCodeButton setFrameWithSize:CGSizeMake(60.0f, 30.0f)];
    self.sendCodeButton.hidden = YES;
    self.numberFieldView.textField.rightView = self.sendCodeButton;
    self.numberFieldView.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.numberFieldView.textField becomeFirstResponder];
    
    self.verificationCodeFieldView = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"验证码",nil)];
    self.verificationCodeFieldView.textField.keyboardType = UIKeyboardTypeDefault;
    self.verificationCodeFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.verificationCodeFieldView];
    
    self.verifyCodeButton = [[HHButton alloc] initThinBorderButtonWithTitle:NSLocalizedString(@"确认验证码",nil) textColor:[UIColor whiteColor]font:[UIFont fontWithName:@"STHeitiSC-Medium" size:10.0f] borderColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    [self.verifyCodeButton addTarget:self action:@selector(verifySMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeButton setFrameWithSize:CGSizeMake(60.0f, 30.0f)];
    self.verificationCodeFieldView.textField.rightView = self.verifyCodeButton;
    self.verificationCodeFieldView.textField.rightViewMode = UITextFieldViewModeWhileEditing;

    [self autoLayoutSubviews];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self.view addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    
    NSArray *constraints = nil;
    
    if (self.type == PageTypeSignup) {
        constraints = @[
                        [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:10.0f],
                        [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                        
                        [HHAutoLayoutUtility verticalNext:self.subTitleLabel toView:self.titleLabel constant:5.0f],
                        [HHAutoLayoutUtility setCenterX:self.subTitleLabel multiplier:1.0f constant:0],
                        
                        [HHAutoLayoutUtility verticalNext:self.numberFieldView toView:self.subTitleLabel constant:10.0f],
                        [HHAutoLayoutUtility setCenterX:self.numberFieldView multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.numberFieldView multiplier:1.0f constant:-80.0f],
                        [HHAutoLayoutUtility setViewHeight:self.numberFieldView multiplier:0 constant:40.0f],
                        
                        [HHAutoLayoutUtility verticalNext:self.verificationCodeFieldView toView:self.numberFieldView constant:5.0f],
                        [HHAutoLayoutUtility setCenterX:self.verificationCodeFieldView multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.verificationCodeFieldView multiplier:1.0f constant:-80.0f],
                        [HHAutoLayoutUtility setViewHeight:self.verificationCodeFieldView multiplier:0 constant:40.0f],
                        
                        ];

    } else {
        constraints = @[
                        [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.numberFieldView constant:20.0f],
                         [HHAutoLayoutUtility setCenterX:self.numberFieldView multiplier:1.0f constant:0],
                         [HHAutoLayoutUtility setViewWidth:self.numberFieldView multiplier:1.0f constant:-80.0f],
                         [HHAutoLayoutUtility setViewHeight:self.numberFieldView multiplier:0 constant:40.0f],
                         
                         [HHAutoLayoutUtility verticalNext:self.verificationCodeFieldView toView:self.numberFieldView constant:10.0f],
                         [HHAutoLayoutUtility setCenterX:self.verificationCodeFieldView multiplier:1.0f constant:0],
                         [HHAutoLayoutUtility setViewWidth:self.verificationCodeFieldView multiplier:1.0f constant:-80.0f],
                         [HHAutoLayoutUtility setViewHeight:self.verificationCodeFieldView multiplier:0 constant:40.0f],
                         
                         ];

    }
    [self.view addConstraints:constraints];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isValidMobileNumber:(NSString *)number {
    NSError *anError = nil;
    NBPhoneNumber *mobileNumber = [self.numberUtil parse:number
                                 defaultRegion:@"CN" error:&anError];
    return [self.numberUtil isValidNumber:mobileNumber];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self isValidMobileNumber:textField.text]) {
        self.sendCodeButton.hidden = NO;
    } else {
        self.sendCodeButton.hidden = YES;
    }
   
}

- (void)sendSMSCode {
    BOOL isSignup = YES;
    if (self.type == PageTypeLogin) {
        isSignup = NO;
    }
    
    if (![[HHUserAuthenticator sharedInstance] isBetaUser:self.numberFieldView.textField.text] && isSignup) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"非常抱歉", nil)
                                                        message:NSLocalizedString(@"哈哈学车目前仅对内测用户开放。内测报名请通过哈哈学车微信公众号（hahaxueche-）进行提交。", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"我知道了", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[HHUserAuthenticator sharedInstance] requestCodeWithNumber:self.numberFieldView.textField.text isSignup:isSignup completion:^(NSError *error) {
        if (error) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"发送失败，请过会重试",nil) isError:YES];
        } else {
            self.verificationCodeFieldView.hidden = NO;
            [self.verificationCodeFieldView.textField becomeFirstResponder];
        }
    }];
    
}

- (void)verifySMSCode {
    //如果是app store测试用户，不用验证
    
#ifdef DEBUG
    if([self.numberFieldView.textField.text isEqualToString:@"18888888888"]) {
        [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
        [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:@"564690fa60b2298f08fb5ba0" completion:^(HHStudent *student, NSError *error) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            if (!error) {
                [HHUserAuthenticator sharedInstance].currentStudent = student;
                HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
                [self presentViewController:rootVC animated:YES completion:nil];
            } else if (error.code == 101) {
                HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
                [self.navigationController pushViewController:profileSetupVC animated:YES];
            } else {
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
            }
        }];
        return;
    }
#else
    
    if([self.numberFieldView.textField.text isEqualToString:@"18888888888"]) {
        [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
        [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:@"5605732560b249ad1f22d232" completion:^(HHStudent *student, NSError *error) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            if (!error) {
                [HHUserAuthenticator sharedInstance].currentStudent = student;
                HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
                [self presentViewController:rootVC animated:YES completion:nil];
            } else if (error.code == 101) {
                HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
                [self.navigationController pushViewController:profileSetupVC animated:YES];
            } else {
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
            }
        }];
        return;
    }


#endif
    
    if (self.type == PageTypeSignup) {
        self.user = [HHUser user];
        self.user.username = self.numberFieldView.textField.text;
        self.user.password = self.numberFieldView.textField.text;
        self.user.mobilePhoneNumber = self.numberFieldView.textField.text;
        self.user.type = kStudentTypeValue;
        [[HHLoadingView sharedInstance] hideLoadingView];
        HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:self.user];
        [self.navigationController pushViewController:profileSetupVC animated:YES];
        
    } else if (self.type == PageTypeLogin) {
        [[HHUserAuthenticator sharedInstance] loginWithNumber:self.numberFieldView.textField.text completion:^(NSError *error) {
            if (!error) {
                if([[HHUserAuthenticator sharedInstance].currentUser.type isEqualToString:kStudentTypeValue]) {
                    [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:[HHUserAuthenticator sharedInstance] .currentUser.objectId completion:^(HHStudent *student, NSError *error) {
                        [[HHLoadingView sharedInstance] hideLoadingView];
                        if (!error) {
                            [[HHEventTrackingManager sharedManager] studentSignedUpOrLoggedIn:student.studentId];
                            [HHUserAuthenticator sharedInstance].currentStudent = student;
                            HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
                            [self presentViewController:rootVC animated:YES completion:nil];
                            
                        } else if (error.code == 101) {
                            HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
                            [self.navigationController pushViewController:profileSetupVC animated:YES];
                        } else {
                            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
                        }
                    }];
                } else {
                    [[HHUserAuthenticator sharedInstance] fetchAuthedCoachWithId:[HHUserAuthenticator sharedInstance].currentUser.objectId completion:^(HHCoach *coach, NSError *error) {
                        [[HHLoadingView sharedInstance] hideLoadingView];
                        if (!error) {
                            [HHUserAuthenticator sharedInstance].currentCoach = coach;
                            HHRootViewController *rootVC = [[HHRootViewController alloc] initForCoach];
                            [self presentViewController:rootVC animated:YES completion:nil];
                        } else if (error.code == 101) {
                            HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
                            [self.navigationController pushViewController:profileSetupVC animated:YES];
                        } else {
                            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
                        }
                        
                    }];
                    
                }
            } else {
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"登陆失败！",nil) isError:YES];
                [[HHLoadingView sharedInstance] hideLoadingView];
            }
        }];
    }

   
//    if([self.numberFieldView.textField.text isEqualToString:@"18888888888"]) {
//        [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
//        [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:@"5605732560b249ad1f22d232" completion:^(HHStudent *student, NSError *error) {
//            [[HHLoadingView sharedInstance] hideLoadingView];
//            if (!error) {
//                [HHUserAuthenticator sharedInstance].currentStudent = student;
//                HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
//                [self presentViewController:rootVC animated:YES completion:nil];
//            } else if (error.code == 101) {
//                HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
//                [self.navigationController pushViewController:profileSetupVC animated:YES];
//            } else {
//                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
//            }
//        }];
//        return;
//    }
//    
//    [self.numberFieldView.textField resignFirstResponder];
//    [self.verificationCodeFieldView.textField resignFirstResponder];
//    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
//    [[HHUserAuthenticator sharedInstance] verifyPhoneNumberWith:self.verificationCodeFieldView.textField.text number:self.numberFieldView.textField.text completion:^(BOOL succeed) {
//        if (succeed) {
//            if (self.type == PageTypeSignup) {
//                self.user = [HHUser user];
//                self.user.username = self.numberFieldView.textField.text;
//                self.user.password = self.numberFieldView.textField.text;
//                self.user.mobilePhoneNumber = self.numberFieldView.textField.text;
//                self.user.type = kStudentTypeValue;
//                [[HHLoadingView sharedInstance] hideLoadingView];
//                HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:self.user];
//                [self.navigationController pushViewController:profileSetupVC animated:YES];
//                
//            } else if (self.type == PageTypeLogin) {
//                [[HHUserAuthenticator sharedInstance] loginWithNumber:self.numberFieldView.textField.text completion:^(NSError *error) {
//                    if (!error) {
//                        if([[HHUserAuthenticator sharedInstance].currentUser.type isEqualToString:kStudentTypeValue]) {
//                            [[HHUserAuthenticator sharedInstance] fetchAuthedStudentWithId:[HHUserAuthenticator sharedInstance] .currentUser.objectId completion:^(HHStudent *student, NSError *error) {
//                                [[HHLoadingView sharedInstance] hideLoadingView];
//                                if (!error) {
//                                    [[HHEventTrackingManager sharedManager] studentSignedUpOrLoggedIn:student.studentId];
//                                    [HHUserAuthenticator sharedInstance].currentStudent = student;
//                                    HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
//                                    [self presentViewController:rootVC animated:YES completion:nil];
//                                    
//                                } else if (error.code == 101) {
//                                    HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
//                                    [self.navigationController pushViewController:profileSetupVC animated:YES];
//                                } else {
//                                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
//                                }
//                            }];
//                        } else {
//                            [[HHUserAuthenticator sharedInstance] fetchAuthedCoachWithId:[HHUserAuthenticator sharedInstance].currentUser.objectId completion:^(HHCoach *coach, NSError *error) {
//                                [[HHLoadingView sharedInstance] hideLoadingView];
//                                if (!error) {
//                                    [HHUserAuthenticator sharedInstance].currentCoach = coach;
//                                    HHRootViewController *rootVC = [[HHRootViewController alloc] initForCoach];
//                                    [self presentViewController:rootVC animated:YES completion:nil];
//                                } else if (error.code == 101) {
//                                    HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] initWithUser:[HHUserAuthenticator sharedInstance].currentUser];
//                                    [self.navigationController pushViewController:profileSetupVC animated:YES];
//                                } else {
//                                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取用户信息失败",nil) isError:YES];
//                                }
//
//                            }];
//
//                        }
//                    } else {
//                        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"登陆失败！",nil) isError:YES];
//                        [[HHLoadingView sharedInstance] hideLoadingView];
//                    }
//                }];
//            }
//        } else {
//            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"验证失败！",nil) isError:YES];
//            [[HHLoadingView sharedInstance] hideLoadingView];
//        }
//    }];
    
}



@end
