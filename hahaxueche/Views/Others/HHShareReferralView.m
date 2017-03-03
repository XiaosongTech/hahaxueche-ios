//
//  HHShareReferralView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHShareReferralView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHShareReferralView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        
        self.topContainerView = [[UIView alloc] init];
        [self addSubview:self.topContainerView];
        [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.width.equalTo(self.width);
            make.left.equalTo(self.left);
            make.height.mas_equalTo(160.0f);
        }];
        
        self.botContainerView = [[UIView alloc] init];
        self.botContainerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.botContainerView];
        [self.botContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topContainerView.bottom);
            make.width.equalTo(self.width);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.bottom);
        }];
        
        self.topBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sharewindow_bg"]];
        [self.topContainerView addSubview:self.topBgView];
        [self.topBgView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topContainerView.bottom);
            make.left.equalTo(self.topContainerView.left);
            make.width.equalTo(self.topContainerView.width);
        }];
        
        self.giftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sharewindow_top"]];
        [self bringSubviewToFront:self.giftView];
        [self addSubview:self.giftView];
        [self.giftView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topContainerView.top);
            make.centerX.equalTo(self.topContainerView.centerX).offset(5.0f);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"推荐有奖";
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self.botContainerView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.botContainerView.top).offset(10.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = text;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor HHTextDarkGray];
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.botContainerView addSubview:self.textLabel];
        [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
            make.centerX.equalTo(self.botContainerView.centerX);
            make.width.equalTo(self.botContainerView.width).offset(-40.0f);
        }];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton setTitle:@"分享得礼品" forState:UIControlStateNormal];
        self.shareButton.backgroundColor = [UIColor HHOrange];
        [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.shareButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self.shareButton addTarget:self action:@selector(shareReferral) forControlEvents:UIControlEventTouchUpInside];
        [self.botContainerView addSubview:self.shareButton];
        [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.botContainerView.width);
            make.height.mas_equalTo(60.0f);
            make.bottom.equalTo(self.botContainerView.bottom);
            make.left.equalTo(self.botContainerView.left);
        }];
    }
    return self;
}

- (void)shareReferral {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
