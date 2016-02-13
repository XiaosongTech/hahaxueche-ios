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
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.followed) {
         [self.followButton setImage:[UIImage imageNamed:@"ic_coachmsg_attention_on"] forState:UIControlStateNormal];
    } else {
         [self.followButton setImage:[UIImage imageNamed:@"ic_coachmsg_attention_hold"] forState:UIControlStateNormal];
    }
   
    [self.followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.followButton sizeToFit];
    [self addSubview:self.followButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareButton];
    
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
    
    self.shareLabel = [[UILabel alloc] init];
    self.shareLabel.text = @"分享";
    self.shareLabel.textColor = [UIColor HHLightTextGray];
    self.shareLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.shareLabel];
    
    self.followLabel = [[UILabel alloc] init];
    if (self.followed) {
        self.followLabel.text = @"已关注";
        self.followLabel.textColor = [UIColor HHOrange];
    } else {
        self.followLabel.text = @"关注";
        self.followLabel.textColor = [UIColor HHLightTextGray];
    }

    self.followLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.followLabel];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.topLine];
    
    [self makeConstraints];

}

- (void)makeConstraints {
    [self.followButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.equalTo(self.top).offset(6.0f);
    }];
    
    [self.followLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.followButton.centerX);
        make.top.equalTo(self.followButton.bottom).offset(4.0f);
    }];
    
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followButton.right).offset(35.0f);
        make.top.equalTo(self.top).offset(6.0f);
    }];
    
    [self.shareLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton.centerX);
        make.top.equalTo(self.shareButton.bottom).offset(4.0f);
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
        [self.followButton setImage:[UIImage imageNamed:@"ic_coachmsg_attention_on"] forState:UIControlStateNormal];
    } else {
        self.followLabel.text = @"关注";
        self.followLabel.textColor = [UIColor HHLightTextGray];
        [self.followButton setImage:[UIImage imageNamed:@"ic_coachmsg_attention_hold"] forState:UIControlStateNormal];
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
    
    self.followed = !self.followed;
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
