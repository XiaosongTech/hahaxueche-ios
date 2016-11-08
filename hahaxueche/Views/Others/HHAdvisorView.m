//
//  HHAdvisorView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/30/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAdvisorView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

@implementation HHAdvisorView

- (instancetype)initWithFrame:(CGRect)frame advisor:(HHAdvisor *)advisor {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        self.advisor = advisor;
        [self initSubviews];

    }
    return self;
}

- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self addSubview:self.topView];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.text = [NSString stringWithFormat:@"嗨, 我是%@, 您的专属学车顾问!", self.advisor.name];
    [self.topView addSubview:self.titleLabel];
    
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.subTitleLabel.minimumScaleFactor = 0.5;
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.text = [NSString stringWithFormat:@"\"%@\"", self.advisor.longIntro];
    self.subTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.topView addSubview:self.subTitleLabel];
    
    self.imgView = [[UIImageView alloc] init];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.advisor.avaURL] placeholderImage:[UIImage imageNamed:@"ic_pop_xiaoha"]];
    self.imgView.layer.cornerRadius = 50.0f;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.topView addSubview:self.imgView];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.botView];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.textColor = [UIColor HHLightTextGray];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.numberOfLines = 1;
    self.infoLabel.minimumScaleFactor = 0.5f;
    self.infoLabel.adjustsFontSizeToFitWidth = YES;
    self.infoLabel.text = @"有问题? 我一直在等您的电话!";
    [self.botView addSubview:self.infoLabel];
    
    self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callButton setBackgroundImage:[UIImage imageNamed:@"ic_call"] forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(callButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.botView addSubview:self.callButton];
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.botView addSubview:self.verticalLine];
    
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(180.0f);
    }];
    
    [self.botView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.centerX.equalTo(self.topView.centerX);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(20.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
        make.width.mas_equalTo(100.0f);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.top);
        make.left.equalTo(self.imgView.right).offset(10.0f);
        make.right.equalTo(self.topView.right).offset(-10.0f);
        make.bottom.lessThanOrEqualTo(self.topView.bottom).offset(-10.0f);
    }];
    
    [self.callButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.centerX.equalTo(self.botView.right).offset(-30.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.right.equalTo(self.botView.right).offset(-60.0f);
        make.height.equalTo(self.botView.height).offset(-20.0f);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        
    }];
    
    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.left.equalTo(self.botView.left).offset(5.0f);
        make.right.equalTo(self.verticalLine.left).offset(-5.0f);
        make.height.equalTo(self.botView.height);
    }];
}

- (void)callButtonTapped {
    if (self.callBlock) {
        self.callBlock();
    }
}

@end
