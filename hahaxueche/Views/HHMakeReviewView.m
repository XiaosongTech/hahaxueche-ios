//
//  HHMakeReviewView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/28/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMakeReviewView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"


@implementation HHMakeReviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"给教练打分";
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.titleLabel];
        
        self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:YES];
        self.starRatingView.value = 5.0f;
        [self addSubview:self.starRatingView];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        
        self.textView = [[UITextView alloc] init];
        self.textView.delegate = self;
        self.textView.textColor = [UIColor  HHLightestTextGray];
        self.textView.font = [UIFont systemFontOfSize:16.0f];
        self.textView.text = kPlaceholder;
        self.textView.returnKeyType = UIReturnKeyDone;
        [self addSubview:self.textView];
        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"确认评价" rightTitle:@"稍后评价"];
        [self.buttonsView.leftButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView.rightButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonsView];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(20.0f);
        make.left.equalTo(self.left).offset(15.0f);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.right).offset(-15.0f);
        make.width.mas_equalTo(120.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(60.0f);
        make.width.equalTo(self.width).offset(-30.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.topLine.bottom);
        make.width.equalTo(self.width).offset(-30.0f);
        make.height.mas_equalTo(120.0f);
    }];
    
    [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.textView.bottom);
        make.width.equalTo(self.width).offset(-30.0f);
        make.height.mas_equalTo(50.0f);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kPlaceholder]) {
        textView.text = @"";
        textView.textColor = [UIColor HHTextDarkGray]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = kPlaceholder;
        textView.textColor = [UIColor HHLightestTextGray]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (void)confirmButtonTapped {
    NSString *comment = self.textView.text;
    if ([comment isEqualToString:kPlaceholder]) {
        comment = @"";
    } else if ([[comment stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        comment = @"";
    }
    if (self.makeReviewBlock) {
        self.makeReviewBlock(@(self.starRatingView.value), comment);
    }
}

- (void)cancelButtonTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


@end
