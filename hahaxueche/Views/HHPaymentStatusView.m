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

#define kNumberLabelRadius 10.0f
#define kDarkGrayTextColor [UIColor colorWithRed:0.37 green:0.36 blue:0.38 alpha:1]

@implementation HHPaymentStatusView


- (instancetype)initWithAmount:(NSNumber *)amount currentStage:(PaymentStage)currentStage stage:(PaymentStage)stage {
    self = [super init];
    if (self) {
        self.amount = amount;
        self.stage = stage;
        self.currentStage = currentStage;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    if (self.currentStage > self.stage) {
        self.numberLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                           textColor:[UIColor HHGrayTextColor]
                                                text:[NSString stringWithFormat:@"%ld", (long)self.stage]
                                     backgroundColor:[UIColor clearColor]];
        
        self.numberLabel.layer.cornerRadius = kNumberLabelRadius;
        
        self.amountLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                           textColor:[UIColor HHGrayTextColor]
                                                text:[[HHFormatUtility moneyFormatter] stringFromNumber:self.amount]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.payButton = [self createButtonWithTitle:NSLocalizedString(@"已付款", nil)
                                     backgroundColor:[UIColor whiteColor]
                                                font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                              action:@selector(payButtonTapped)
                                           textColor:[UIColor HHGrayTextColor]];
        self.payButton.enabled = NO;
        
    } else if (self.currentStage == self.stage) {
        self.numberLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                           textColor:[UIColor whiteColor]
                                                text:[NSString stringWithFormat:@"%ld", (long)self.stage]
                                     backgroundColor:[UIColor HHOrange]];
        self.numberLabel.layer.cornerRadius = kNumberLabelRadius;
        
        self.amountLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                           textColor:[UIColor HHOrange]
                                                text:[[HHFormatUtility moneyFormatter] stringFromNumber:self.amount]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.payButton = [self createButtonWithTitle:NSLocalizedString(@"付款", nil)
                                     backgroundColor:[UIColor HHOrange]
                                                font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                              action:@selector(payButtonTapped)
                                           textColor:[UIColor whiteColor]];
        self.payButton.enabled = YES;
        
    } else {
        self.numberLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                           textColor:kDarkGrayTextColor
                                                text:[NSString stringWithFormat:@"%ld", (long)self.stage]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.numberLabel.layer.cornerRadius = kNumberLabelRadius;
        self.numberLabel.layer.borderWidth = 1.0f;
        self.numberLabel.layer.borderColor = [UIColor HHGrayTextColor].CGColor;
        
        
        self.amountLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                           textColor:kDarkGrayTextColor
                                                text:[[HHFormatUtility moneyFormatter] stringFromNumber:self.amount]
                                     backgroundColor:[UIColor whiteColor]];
        
        self.payButton = [self createButtonWithTitle:NSLocalizedString(@"待付款", nil)
                                     backgroundColor:[UIColor whiteColor]
                                                font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f]
                                              action:@selector(payButtonTapped)
                                           textColor:kDarkGrayTextColor];
        self.payButton.enabled = NO;
    }
    self.infoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.infoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoImageView.image = [UIImage imageNamed:@"info"];
    self.infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolTip)];
    [self.infoImageView addGestureRecognizer:tapGesture];
    [self addSubview:self.infoImageView];
    
    [self autoLayoutSubviews];
    
}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterY:self.numberLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.numberLabel constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.numberLabel multiplier:0 constant:kNumberLabelRadius * 2],
                             [HHAutoLayoutUtility setViewWidth:self.numberLabel multiplier:0 constant:kNumberLabelRadius * 2],
                             
                             [HHAutoLayoutUtility setCenterY:self.amountLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.amountLabel toView:self.numberLabel constant:30.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.payButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.payButton multiplier:2.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewWidth:self.payButton multiplier:0 constant:50.0f],
                             
                             
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
    
}

- (void)showToolTip {
    
}

@end
