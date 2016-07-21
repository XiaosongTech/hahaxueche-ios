//
//  HHActivateCouponView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHActivateCouponView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHActivateCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.topView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"优惠券激活";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self.topView addSubview:self.titleLabel];
        
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.font = [UIFont systemFontOfSize:15.0f];
        self.infoLabel.textColor = [UIColor HHLightTextGray];
        self.infoLabel.text = @"即日起, 在哈哈学车上报名即可激活该优惠券, 激活成功后可在线下渠道商领取相应优惠! 赶紧开始免费试学吧!";
        [self addSubview:self.infoLabel];
        
        self.freeTrialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.freeTrialButton setTitle:@"我要免费试学" forState:UIControlStateNormal];
        [self.freeTrialButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.freeTrialButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.freeTrialButton.backgroundColor = [UIColor colorWithRed:0.99 green:0.45 blue:0.14 alpha:1.00];
        self.freeTrialButton.layer.cornerRadius = 25.0f;
        self.freeTrialButton.layer.masksToBounds = YES;
        [self.freeTrialButton addTarget:self action:@selector(freeTrialButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.freeTrialButton];
        
        
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(60.0f);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView.centerY);
            make.left.equalTo(self.topView.left).offset(30.0f);
        }];
        
        [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.topView.bottom).offset(20.0f);
            make.width.mas_equalTo(250.0f);
        }];
        
        [self.freeTrialButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.infoLabel.bottom).offset(20.0f);
            make.width.mas_equalTo(250.0f);
            make.height.mas_equalTo(50.0f);
        }];
        
    }
    return self;
}

- (void)freeTrialButtonTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
