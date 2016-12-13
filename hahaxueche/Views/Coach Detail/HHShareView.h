//
//  HHShareView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SocialMedia) {
    SocialMediaQQFriend, // QQ好友
    SocialMediaWeChatFriend, // 微信好友
    SocialMediaQZone, // qq空间
    SocialMediaWeChaPYQ,    // 微信朋友圈
    SocialMediaWeibo, // 微博
    SocialMediaMessage, // 短信
    SocialMediaCount
};

typedef void (^HHShareViewDissmissBlock)();
typedef void (^HHShareViewBlock)(SocialMedia selectedItem);

@interface HHShareView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *itemsView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *cancelLabel;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHShareViewDissmissBlock dismissBlock;
@property (nonatomic, strong) HHShareViewBlock actionBlock;

@property (nonatomic, strong) NSMutableArray *items;

@end
