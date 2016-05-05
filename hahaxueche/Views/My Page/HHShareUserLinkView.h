//
//  HHShareUserLinkView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SocialMedia) {
    SocialMediaQQFriend, // QQ好友
    SocialMediaWeibo, // 微博
    SocialMediaWeChatFriend, // 微信好友
    SocialMediaWeChaPYQ,    // 微信朋友圈
};

typedef void (^HHShareUserLinkBlock)();
typedef void (^HHShareSocial)(SocialMedia type);

@interface HHShareUserLinkView : UIView

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *pasteLinkButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *shareContainerView;;
@property (nonatomic, strong) UIButton *qq;
@property (nonatomic, strong) UIButton *weibo;
@property (nonatomic, strong) UIButton *weChat;
@property (nonatomic, strong) UIButton *weChatTimeLine;

@property (nonatomic, strong) HHShareUserLinkBlock messageBlock;
@property (nonatomic, strong) HHShareUserLinkBlock pasteBlock;
@property (nonatomic, strong) HHShareUserLinkBlock cancelBlock;
@property (nonatomic, strong) HHShareSocial socialBlock;


@end
