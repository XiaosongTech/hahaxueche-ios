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

- (instancetype)initWithFrame:(CGRect)frame followed:(BOOL)followed {
    self = [super initWithFrame:frame];
    if (self) {
        self.followed = followed;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.followIconView = [[UIImageView alloc] init];
    if (self.followed) {
        self.followIconView.image = [UIImage imageNamed:@"ic_coachmsg_attention_on"];
    } else {
        self.followIconView.image = [UIImage imageNamed:@"ic_coachmsg_attention_hold"];
    }
    [self addSubview:self.followIconView];
    
    self.shareIconView = [[UIImageView alloc] init];
    self.shareIconView.image = [UIImage imageNamed:@"ic_coachmsg_sharecoach"];
    [self addSubview:self.shareIconView];
    
    self.tryCoachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tryCoachButton setTitle:@"免费试学" forState:UIControlStateNormal];
    [self.tryCoachButton setBackgroundColor:[UIColor HHOrange]];
    [self.tryCoachButton addTarget:self action:@selector(tryCoachButtonTapped)
                  forControlEvents:UIControlEventTouchUpInside];
    self.tryCoachButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:self.tryCoachButton];
    
    self.purchaseCoachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.purchaseCoachButton setTitle:@"确认并付款" forState:UIControlStateNormal];
    self.purchaseCoachButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.purchaseCoachButton setBackgroundColor:[UIColor colorWithRed:0.99 green:0.45 blue:0.13 alpha:1]];
    [self.purchaseCoachButton addTarget:self action:@selector(purchaseCoachButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.purchaseCoachButton];
    
    
    self.followContainerView = [[UIView alloc] init];
    self.followContainerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecignizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followButtonTapped)];
    [self.followContainerView addGestureRecognizer:tapRecignizer];

    [self addSubview:self.followContainerView];
    
    
    self.shareContainerView = [[UIView alloc] init];
    self.shareContainerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecignizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonTapped)];
    [self.shareContainerView addGestureRecognizer:tapRecignizer2];
    [self addSubview:self.shareContainerView];
    
    self.shareLabel = [[UILabel alloc] init];
    self.shareLabel.text = @"分享";
    self.shareLabel.textColor = [UIColor HHLightTextGray];
    self.shareLabel.font = [UIFont systemFontOfSize:10];
    
    [self.shareContainerView addSubview:self.shareLabel];
    
    self.followLabel = [[UILabel alloc] init];
    if (self.followed) {
        self.followLabel.text = @"已关注";
        self.followLabel.textColor = [UIColor HHOrange];
    } else {
        self.followLabel.text = @"关注";
        self.followLabel.textColor = [UIColor HHLightTextGray];
    }

    self.followLabel.font = [UIFont systemFontOfSize:10];
    [self.followContainerView addSubview:self.followLabel];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.topLine];
    
    [self makeConstraints];

}

- (void)makeConstraints {
    
    [self.followContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.width.mas_equalTo(62.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.shareContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(62.0f);
        make.top.equalTo(self.top);
        make.width.mas_equalTo(62.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.followIconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.followContainerView.centerX);
        make.top.equalTo(self.top).offset(6.0f);
    }];
    
    [self.followLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.followIconView.centerX);
        make.top.equalTo(self.followIconView.bottom).offset(4.0f);
    }];
    
    [self.shareIconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareContainerView.centerX);
        make.top.equalTo(self.top).offset(6.0f);
    }];
    
    [self.shareLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareIconView.centerX);
        make.top.equalTo(self.shareIconView.bottom).offset(4.0f);
    }];
    
    [self.tryCoachButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(62.0f * 2.0f);
        make.top.equalTo(self.top);
        make.width.mas_equalTo((CGRectGetWidth(self.bounds)-124.0f)/2.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.purchaseCoachButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tryCoachButton.right);
        make.top.equalTo(self.top);
        make.width.mas_equalTo((CGRectGetWidth(self.bounds)-124.0f)/2.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

- (void)setFollowed:(BOOL)followed {
    _followed = followed;
    if (self.followed) {
        self.followLabel.text = @"已关注";
        self.followLabel.textColor = [UIColor HHOrange];
        self.followIconView.image = [UIImage imageNamed:@"ic_coachmsg_attention_on"];
    } else {
        self.followLabel.text = @"关注";
        self.followLabel.textColor = [UIColor HHLightTextGray];
        self.followIconView.image = [UIImage imageNamed:@"ic_coachmsg_attention_hold"];
    }
}

#pragma mark - Button Actions 

- (void)followButtonTapped {
    if (self.followed) {
        if (self.unFollowAction) {
            self.unFollowAction();
        }
    } else {
        if (self.followAction) {
            self.followAction();
        }
    }
}

- (void)shareButtonTapped {
    if (self.shareAction) {
        self.shareAction();
    }
}

- (void)tryCoachButtonTapped {
    if (self.tryCoachAction) {
        self.tryCoachAction();
    }
}

- (void)purchaseCoachButtonTapped {
    if (self.purchaseCoachAction) {
        self.purchaseCoachAction();
    }
}

@end
