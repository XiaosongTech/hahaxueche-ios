//
//  HHPaymentStatusView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/28/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStatusView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHFormatUtility.h"
#import "HHUserAuthenticator.h"

#define kNumberLabelRadius 10.0f
#define kGreenColor [UIColor colorWithRed:0.39 green:0.75 blue:0.01 alpha:1]

@implementation HHPaymentStatusView


- (instancetype)initWithAmount:(NSNumber *)amount currentStage:(PaymentStage)currentStage stage:(PaymentStage)stage paidDate:(NSString *)paidDate {
    self = [super init];
    if (self) {
        self.amount = amount;
        self.stage = stage;
        self.currentStage = currentStage;
        self.backgroundColor = [UIColor whiteColor];
        self.paidDate = paidDate;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    if (self.currentStage > self.stage) {
        NSString *payButtonText = NSLocalizedString(@"已付款", nil);
        if ([HHUserAuthenticator sharedInstance].currentCoach) {
            payButtonText = NSLocalizedString(@"学员已付款", nil);
        }

        self.numberLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                           textColor:[UIColor HHGrayTextColor]
                                                text:[NSString stringWithFormat:@"%ld", (long)self.stage]
                                     backgroundColor:[UIColor clearColor]];
        
        self.numberLabel.layer.cornerRadius = kNumberLabelRadius;
        
        self.amountLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                           textColor:[UIColor HHGrayTextColor]
                                                text:[[HHFormatUtility moneyFormatter] stringFromNumber:self.amount]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.payButton = [self createButtonWithTitle:payButtonText
                                     backgroundColor:[UIColor whiteColor]
                                                font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                              action:@selector(payButtonTapped)
                                           textColor:[UIColor HHGrayTextColor]];
        self.payButton.enabled = NO;
        
    } else if (self.currentStage == self.stage) {
        self.numberLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                           textColor:[UIColor whiteColor]
                                                text:[NSString stringWithFormat:@"%ld", (long)self.stage]
                                     backgroundColor:[UIColor HHOrange]];
        self.numberLabel.layer.cornerRadius = kNumberLabelRadius;
        
        self.amountLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                           textColor:[UIColor HHOrange]
                                                text:[[HHFormatUtility moneyFormatter] stringFromNumber:self.amount]
                                     backgroundColor:[UIColor whiteColor]];
        UIColor *payButtonBGColor = [UIColor HHOrange];
        UIColor *payButtonTextColor = [UIColor whiteColor];
        NSString *payButtonText = NSLocalizedString(@"付款", nil);
        if ([HHUserAuthenticator sharedInstance].currentCoach) {
            payButtonBGColor  = [UIColor whiteColor];
            payButtonTextColor = [UIColor HHOrange];
            payButtonText = NSLocalizedString(@"待学员付款", nil);
        }
        self.payButton = [self createButtonWithTitle:payButtonText
                                     backgroundColor:payButtonBGColor
                                                font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                              action:@selector(payButtonTapped)
                                           textColor:payButtonTextColor];
        self.payButton.enabled = YES;
        
    } else {
        NSString *payButtonText = NSLocalizedString(@"待付款", nil);
        if ([HHUserAuthenticator sharedInstance].currentCoach) {
            payButtonText = NSLocalizedString(@"待学员付款", nil);
        }
        self.numberLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                           textColor:[UIColor HHDarkGrayTextColor]
                                                text:[NSString stringWithFormat:@"%ld", (long)self.stage]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.numberLabel.layer.cornerRadius = kNumberLabelRadius;
        self.numberLabel.layer.borderWidth = 1.0f;
        self.numberLabel.layer.borderColor = [UIColor HHGrayTextColor].CGColor;
        
        
        self.amountLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                           textColor:[UIColor HHDarkGrayTextColor]
                                                text:[[HHFormatUtility moneyFormatter] stringFromNumber:self.amount]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.payButton = [self createButtonWithTitle:payButtonText
                                     backgroundColor:[UIColor whiteColor]
                                                font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
                                              action:@selector(payButtonTapped)
                                           textColor:[UIColor HHDarkGrayTextColor]];
        self.payButton.enabled = NO;
    }
    self.infoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.infoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoImageView.image = [UIImage imageNamed:@"info"];
    self.infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.infoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolTip)];
    [self.infoImageView addGestureRecognizer:tapGesture];
    [self addSubview:self.infoImageView];
    [self autoLayoutSubviews];
    
    if ([HHUserAuthenticator sharedInstance].currentCoach) {
        self.payButton.enabled = NO;
    }
}


- (void)autoLayoutSubviews {
    NSInteger buttonLWidth = 50.0f;
    if ([HHUserAuthenticator sharedInstance].currentCoach) {
        buttonLWidth = 70.0f;
    }
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterY:self.numberLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.numberLabel constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.numberLabel multiplier:0 constant:kNumberLabelRadius * 2],
                             [HHAutoLayoutUtility setViewWidth:self.numberLabel multiplier:0 constant:kNumberLabelRadius * 2],
                             
                             [HHAutoLayoutUtility setCenterY:self.amountLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.amountLabel toView:self.numberLabel constant:30.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.payButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.payButton multiplier:2.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewWidth:self.payButton multiplier:0 constant:buttonLWidth],
                             
                             
                             [HHAutoLayoutUtility setCenterY:self.infoImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.infoImageView multiplier:2.0f constant:-20.0f],
                             
                             
                             ];
    [self addConstraints:constraints];
}

- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text backgroundColor:(UIColor *)bgColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = bgColor;
    label.text = text;
    [label sizeToFit];
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    return label;
}

- (UIButton *)createButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor font:(UIFont *)font action:(SEL)action textColor:(UIColor *)textColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setBackgroundColor:bgColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button sizeToFit];
    return button;
}

- (void)payButtonTapped {
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确认付款？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消付款", nil) otherButtonTitles:NSLocalizedString(@"确认付款", nil), nil];
    [self.alertView show];
    
}

- (void)showToolTip {
    NSString *title;
    NSString *message;
    UIColor *titleColor;
    
    if (self.currentStage > self.stage) {
        titleColor = kGreenColor;
        title = [NSString stringWithFormat:NSLocalizedString(@"%@  已付款", nil), self.paidDate];
    } else {
        titleColor = [UIColor HHDarkGrayTextColor];
        title = NSLocalizedString(@"未付款", nil);
    }

    
    switch (self.stage) {
        case StageOne: {
            if ([HHUserAuthenticator sharedInstance].currentStudent) {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第一阶段：确认付款后，我们会将%@元自动转到教练账户。\n", nil), [self.amount stringValue]];
            } else {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第一阶段：学员确认付款后，我们会将%@元转到您的账户。\n", nil), [self.amount stringValue]];
            }
           
        } break;
        case StageTwo: {
            if ([HHUserAuthenticator sharedInstance].currentStudent) {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第二阶段：确认需要预约科目一考试后，点击付款按钮后，我们会将%@元转到教练账户。\n", nil), [self.amount stringValue]];
            } else {
                message = [NSString stringWithFormat: NSLocalizedString(@"\n第二阶段：学员确认需要预约科目一考试，点击付款按钮后，我们会将%@元转到您到账户。\n", nil), [self.amount stringValue]];
            }

           
        } break;
        case StageThree: {
            
            if ([HHUserAuthenticator sharedInstance].currentStudent) {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第三阶段：确认通过科目二后，点击付款按钮，我们会将%@元转到教练账户。\n", nil), [self.amount stringValue]];
            } else {
                message = [NSString stringWithFormat: NSLocalizedString(@"\n第三阶段：学员确认通过科目二后，点击付款按钮，我们会将%@元转到您到账户。\n", nil), [self.amount stringValue]];
            }
           
        } break;
        case StageFour: {
            
            if ([HHUserAuthenticator sharedInstance].currentStudent) {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第四阶段：确认通过科目三后，点击付款按钮，我们会将%@元转到教练账户。\n", nil), [self.amount stringValue]];
            } else {
                message = [NSString stringWithFormat: NSLocalizedString(@"\n第四阶段：学员确认通过科目三后，点击付款按钮，我们会将%@元转到您到账户。\n", nil), [self.amount stringValue]];
            }
           
        } break;
        case StageFive: {
            if ([HHUserAuthenticator sharedInstance].currentStudent) {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第五阶段：确认通过科目四并且拿到驾驶证后，点击付款按钮，我们会将剩下的所有金额（%@元）转到教练账户。\n", nil), [self.amount stringValue]];
            } else {
                 message = [NSString stringWithFormat: NSLocalizedString(@"\n第五阶段：学员确认通过科目四并且拿到驾驶证后，点击付款按钮，我们会将剩下的所有金额（%@元）转到您到账户。\n", nil), [self.amount stringValue]];
            }
           
        } break;
            
        default:
            break;
    }
    
    CMPopTipView *view = [[CMPopTipView alloc] initWithTitle:title message:message];
    view.textAlignment = NSTextAlignmentLeft;
    view.titleColor = titleColor;
    view.titleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0f];
    view.textFont = [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f];
    view.textColor = [UIColor HHGrayTextColor];
    view.preferredPointDirection = PointDirectionAny;
    view.borderColor = [UIColor HHOrange];
    view.borderWidth = 1.0f;
    view.has3DStyle = NO;
    view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    view.disableTapToDismiss = YES;
    view.dismissTapAnywhere = YES;
    view.sidePadding = 5.0f;
    view.topMargin = 5.0f;
    view.pointerSize = 5.0f;
    view.cornerRadius = 5.0f;
    view.delegate = self;
    view.hasShadow = NO;
    view.hasGradientBackground = NO;
    [view presentPointingAtView:self.infoImageView inView:self.superview animated:YES];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    popTipView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.payBlock) {
            self.payBlock();
        }
    }
}

@end
