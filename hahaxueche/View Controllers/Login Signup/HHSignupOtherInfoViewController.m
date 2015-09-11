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

@interface HHSignupOtherInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHTextFieldView *referCodeField;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *coachId;



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
    if (self.coachId){
        self.student.myCoachId = self.coachId;
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

- (void)initSubviews {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = NSLocalizedString(@"扫一扫", nil);
    [self.titleLabel sizeToFit];
    [self.view addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.text = NSLocalizedString(@"如果已有教练，可以点击方块扫描教练二维码（可选）", nil);
    [self.subTitleLabel sizeToFit];
    [self.view addSubview:self.subTitleLabel];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.image = [UIImage imageNamed:@"qrcode_btn"];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    
    self.referCodeField = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"邀请码(可选)", nil)];
    self.referCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.referCodeField.textField setReturnKeyType:UIReturnKeyDone];
    self.referCodeField.textField.delegate = self;
    [self.view addSubview:self.referCodeField];
    
    [self autoLayoutSubviews];
    
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:20.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.subTitleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.subTitleLabel toView:self.titleLabel constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.imageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.imageView toView:self.subTitleLabel constant:20.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.referCodeField multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.referCodeField toView:self.imageView constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.referCodeField multiplier:1.0f constant:-60.0f],
                             [HHAutoLayoutUtility setViewHeight:self.referCodeField multiplier:0 constant:40.0f]
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


@end
