//
//  HHConfirmWithdrawView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGenericTwoButtonsPopupView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHGenericTwoButtonsPopupView

- (instancetype)initWithTitle:(NSString *)title info:(NSMutableAttributedString *)info leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.title = title;
        self.info = info;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
        
        CGRect rect = [info boundingRectWithSize:CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds)-60.0f), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-20.0f, 160.0f + CGRectGetHeight(rect));
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.topView addSubview:self.titleLabel];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.attributedText = self.info;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.infoLabel];
    
    
    self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:self.leftButtonTitle rightTitle:self.rightButtonTitle];
    [self.buttonsView.leftButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.rightButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonsView];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];

    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.top.equalTo(self.topView.bottom).offset(20.0f);
    }];
    
    [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
    }];
}

- (void)cancelTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmTapped {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}




@end
