//
//  HHShareUserLinkView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHShareUserLinkView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIImage+HHImage.h"
#import "NSNumber+HHNumber.h"

@implementation HHShareUserLinkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.3f alpha:0.2f]];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.frame;
    [self.bgImageView addSubview:visualEffectView];
    [self addSubview:self.bgImageView];
    
    [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.width);
        make.height.equalTo(self.height);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"分享您的哈哈学车专属链接";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(100.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.topLine];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(25.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.text = [NSString stringWithFormat:@"在哈哈学车上送给好友%@\n当好友报名时您可以获得%@", [@(5000) generateMoneyString], [@(5000) generateMoneyString]];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:self.subTitleLabel];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.bottom).offset(25.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    self.messageButton = [self buildButtonWithTitle:@"短信分享"];
    [self.messageButton addTarget:self action:@selector(shareWithMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.messageButton];
    [self.messageButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.bottom).offset(50.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    self.pasteLinkButton = [self buildButtonWithTitle:@"复制链接"];
    [self.pasteLinkButton addTarget:self action:@selector(pasteLink) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pasteLinkButton];
    [self.pasteLinkButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageButton.bottom).offset(15.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    self.shareContainerView = [[UIView alloc] init];
    self.shareContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shareContainerView];
    [self.shareContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-150.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    self.qq = [self buildShareButtonWithType:SocialMediaQQFriend];
    [self.shareContainerView addSubview:self.qq];
    [self.qq makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareContainerView.centerX).multipliedBy(1.0f/4.0f);
        make.centerY.equalTo(self.shareContainerView.centerY);
    }];
    
    self.weibo = [self buildShareButtonWithType:SocialMediaWeibo];
    [self.shareContainerView addSubview:self.weibo];
    [self.weibo makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareContainerView.centerX).multipliedBy(3.0f/4.0f);
        make.centerY.equalTo(self.shareContainerView.centerY);
    }];
    
    self.weChat = [self buildShareButtonWithType:SocialMediaWeChatFriend];
    [self.shareContainerView addSubview:self.weChat];
    [self.weChat makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareContainerView.centerX).multipliedBy(5.0f/4.0f);
        make.centerY.equalTo(self.shareContainerView.centerY);
    }];
    
    self.weChatTimeLine = [self buildShareButtonWithType:SocialMediaWeChaPYQ];
    [self.shareContainerView addSubview:self.weChatTimeLine];
    [self.weChatTimeLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareContainerView.centerX).multipliedBy(7.0f/4.0f);
        make.centerY.equalTo(self.shareContainerView.centerY);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"ic_share_close_btn"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-60.0f);
        make.centerX.equalTo(self.centerX);
    }];
}

- (UIButton *)buildButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    button.backgroundColor = [UIColor clearColor];
    return button;
}

- (UIButton *)buildShareButtonWithType:(SocialMedia)type {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = type;
    
    switch (type) {
        case SocialMediaQQFriend: {
            [button setImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_qq"] forState:UIControlStateNormal];
        } break;
            
        case SocialMediaWeibo: {
            [button setImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_weibo"] forState:UIControlStateNormal];
        } break;
            
        case SocialMediaWeChatFriend: {
            [button setImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_wechat"] forState:UIControlStateNormal];
        } break;
            
        case SocialMediaWeChaPYQ: {
            [button setImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_friendgroup"] forState:UIControlStateNormal];
        } break;
            
        default:
            break;
    }
    [button addTarget:self action:@selector(shareLinkToSocialMedia:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)shareWithMessage {
    if (self.messageBlock) {
        self.messageBlock();
    }
}

- (void)pasteLink {
    if (self.pasteBlock) {
        self.pasteBlock();
    }
}

- (void)shareLinkToSocialMedia:(UIButton *)button {
    if (self.socialBlock) {
        self.socialBlock(button.tag);
    }
}

- (void)dismissView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
