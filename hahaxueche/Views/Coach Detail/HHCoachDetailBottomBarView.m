//
//  HHCoachDetailBottomBarView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailBottomBarView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"


@implementation HHCoachDetailBottomBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    
    self.tryCoachButton = [[HHGradientButton alloc] initWithType:0];
    [self.tryCoachButton setTitle:@"免费试学" forState:UIControlStateNormal];
    [self.tryCoachButton addTarget:self action:@selector(tryCoachButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.tryCoachButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:self.tryCoachButton];
    
    self.supportButton = [[HHGradientButton alloc] initWithType:1];
    [self.supportButton setAttributedTitle:[self generateStringWithImage:[UIImage imageNamed:@"ic_coachdetails_kefu"]] forState:UIControlStateNormal];
    [self.supportButton addTarget:self action:@selector(supportButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.supportButton];
    
    self.smsButton = [[HHGradientButton alloc] initWithType:1];
    [self.smsButton setAttributedTitle:[self generateStringWithImage:[UIImage imageNamed:@"ic_coachdetails_message"]] forState:UIControlStateNormal];
    [self.smsButton addTarget:self action:@selector(smsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.smsButton];
    
    self.callButton = [[HHGradientButton alloc] initWithType:1];
    [self.callButton setAttributedTitle:[self generateStringWithImage:[UIImage imageNamed:@"ic_coachdetails_phone"]] forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(callButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.callButton];
    
    
    [self makeConstraints];

}

- (void)makeConstraints {
    
    [self.tryCoachButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.width.equalTo(self.width).multipliedBy(2.0f/5.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.supportButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tryCoachButton.right);
        make.top.equalTo(self.top);
        make.width.equalTo(self.width).multipliedBy(1.0f/5.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.smsButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.supportButton.right);
        make.top.equalTo(self.top);
        make.width.equalTo(self.width).multipliedBy(1.0f/5.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.callButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smsButton.right);
        make.top.equalTo(self.top);
        make.width.equalTo(self.width).multipliedBy(1.0f/5.0f);
        make.height.equalTo(self.height);
    }];
    
}


#pragma mark - Button Actions

- (void)tryCoachButtonTapped {
    if (self.tryCoachAction) {
        self.tryCoachAction();
    }
}

- (void)supportButtonTapped {
    if (self.supportAction) {
        self.supportAction();
    }
}
- (void)smsButtonTapped {
    if (self.smsAction) {
        self.smsAction();
    }
}

- (void)callButtonTapped {
    if (self.callAction) {
        self.callAction();
    }
}

- (NSAttributedString *)generateStringWithImage:(UIImage *)img {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;

    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = img;
    textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
    
    return [NSAttributedString attributedStringWithAttachment:textAttachment];
    
}

@end
