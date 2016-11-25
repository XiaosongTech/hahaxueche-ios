//
//  HHGenericOneButtonPopupView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGenericOneButtonPopupView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHGenericOneButtonPopupView


- (instancetype)initWithTitle:(NSString *)title info:(NSMutableAttributedString *)info  {
    self = [super init];
    if (self) {
        CGRect rect = [info boundingRectWithSize:CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds)-60.0f), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-20.0f, 160.0f + CGRectGetHeight(rect));
        self.backgroundColor = [UIColor whiteColor];
        self.title = title;;
        self.info = info;
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
    [self addSubview:self.infoLabel];
    
    
    self.buttonView = [[HHOkButtonView alloc] init];;
    [self.buttonView.okButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonView];
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
        make.top.equalTo(self.topView.bottom).offset(20.0f);
        make.width.equalTo(self.width).offset(-40.0f);
    }];
    
    [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.bottom).offset(20.0f);
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


@end
