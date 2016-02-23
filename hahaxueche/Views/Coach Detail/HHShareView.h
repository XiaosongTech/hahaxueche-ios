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
    SocialMediaQQZone, // QQ空间
    SocialMediaWeChatFriend, // 微信好友
    SocialMediaWeChaPYQ,    // 微信朋友圈
    SocialMediaCount
};

typedef void (^HHShareViewDissmissBlock)();
typedef void (^HHShareViewBlock)(SocialMedia selectedItem);

@interface HHShareView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *itemsView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) HHShareViewDissmissBlock dismissBlock;
@property (nonatomic, strong) HHShareViewBlock actionBlock;

@property (nonatomic, strong) NSMutableArray *items;

@end
