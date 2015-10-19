//
//  HHSignupOtherInfoViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/10/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHSignupOtherInfoViewController.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "HHTextFieldView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHReferral.h"
#import "HHRootViewController.h"
#import "HHAvatarView.h"
#import "HHCoachService.h"
#import <QRCodeReaderViewController.h>
#import "HHCoachService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHUserAuthenticator.h"
#import "HHLoadingView.h"

#define kAvatarRadius 30.0f

@interface HHSignupOtherInfoViewController () <UITextFieldDelegate, QRCodeReaderDelegate>

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHTextFieldView *referCodeField;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) HHCoach *myCoach;

@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;



@end

@implementation HHSignupOtherInfoViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHOrange];
    self.title = NSLocalizedString(@"其他信息", nil);
    
    UIBarButtonItem *doneButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"完成", nil) action:@selector(donePressed) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self initSubviews];
    
}

- (void)donePressed {
    if (self.myCoach){
        self.student.myCoachId = self.myCoach.coachId;
        [HHUserAuthenticator sharedInstance].currentStudent = self.student;
        [HHUserAuthenticator sharedInstance].myCoach.currentStudentAmount = @([[HHUserAuthenticator sharedInstance].myCoach.currentStudentAmount integerValue] + 1);
        [HHUserAuthenticator sharedInstance].myCoach = self.myCoach;
        [[HHUserAuthenticator sharedInstance].myCoach saveInBackground];
        [self.student saveInBackground];
    }
    if (![self.referCodeField.textField.text isEqualToString:@""]) {
        HHReferral *referral = [HHReferral object];
        referral.referCode = self.referCodeField.textField.text;
        referral.studentId = self.student.studentId;
        [referral saveInBackground];
    }
    
    HHRootViewController *rootVC = [[HHRootViewController alloc] initForStudent];
    [self presentViewController:rootVC animated:YES completion:nil];
    
}

- (void)setMyCoach:(HHCoach *)myCoach{
    _myCoach = myCoach;
    if (self.myCoach) {
        self.titleLabel.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.qrCodeImageView.hidden = YES;
        self.avatarView.hidden = NO;
        self.nameLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = NO;
        self.subTitleLabel.hidden = NO;
        self.qrCodeImageView.hidden = NO;
        self.avatarView.hidden = YES;
        self.nameLabel.hidden = YES;
    }
  
}

- (void)initSubviews {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.titleLabel = [self createLabelWithTitle:NSLocalizedString(@"扫一扫", nil) font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] textColor:[UIColor whiteColor]];
    [self.view addSubview:self.titleLabel];
    
    self.subTitleLabel = [self createLabelWithTitle:NSLocalizedString(@"如果已有教练，可以点击方块扫描教练二维码（可选）", nil) font:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f] textColor:[UIColor whiteColor]];
    [self.view addSubview:self.subTitleLabel];
    
    self.qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.qrCodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.qrCodeImageView.image = [UIImage imageNamed:@"qrcode_btn"];
    self.qrCodeImageView.contentMode = UIViewContentModeCenter;
    self.qrCodeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToQRScanVC)];
    [self.qrCodeImageView addGestureRecognizer:tapRecgnizer];
    [self.view addSubview:self.qrCodeImageView];
   
    
    self.referCodeField = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"邀请码(可选)", nil)];
    self.referCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.referCodeField.textField setReturnKeyType:UIReturnKeyDone];
    self.referCodeField.textField.delegate = self;
    [self.view addSubview:self.referCodeField];
    
    self.nameLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] textColor:[UIColor whiteColor]];
    self.nameLabel.hidden = YES;
    [self.view addSubview:self.nameLabel];
    
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarView.hidden = YES;
    [self.view addSubview:self.avatarView];
    
    
    [self autoLayoutSubviews];
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = textColor;
    [label sizeToFit];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:20.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.subTitleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.subTitleLabel toView:self.titleLabel constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.qrCodeImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.qrCodeImageView toView:self.subTitleLabel constant:20.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.referCodeField multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.referCodeField toView:self.qrCodeImageView constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.referCodeField multiplier:1.0f constant:-60.0f],
                             [HHAutoLayoutUtility setViewHeight:self.referCodeField multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.avatarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius * 2.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius * 2.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.nameLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             
                             ];
    [self.view addConstraints:constraints];
    
}

- (void)keyboardWillShow:(NSNotification *)dic {
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = -36.0f;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)dic {
   
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 64;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)jumpToQRScanVC {
    QRCodeReaderViewController *scanVC = [[QRCodeReaderViewController alloc] init];
    scanVC.delegate = self;
    scanVC.view.backgroundColor = [UIColor HHOrange];
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    __weak HHSignupOtherInfoViewController *weakSelf = self;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        if (result) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            [[HHCoachService sharedInstance] fetchCoachWithId:result completion:^(HHCoach *coach, NSError *error) {
                if (!error) {
                    weakSelf.myCoach = coach;
                    [weakSelf.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:coach.avatarURL] placeholderImage:nil];
                    weakSelf.nameLabel.text = coach.fullName;
                } else {
                    weakSelf.myCoach = nil;
                }
            }];
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
