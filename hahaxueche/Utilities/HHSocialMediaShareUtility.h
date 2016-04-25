//
//  HHSocialMediaShareUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenShareHeader.h"
#import "HHCoach.h"

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeQQ,
    ShareTypeQZone,
    ShareTypeWeChat,
    ShareTypeWeChatTimeLine,
};

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeShareCoach,
    MessageTypeUserReferLink,
};

typedef void (^MessageCompletion) (OSMessage *message);

@interface HHSocialMediaShareUtility : NSObject

+ (void)configure;

+ (void)shareCoach:(HHCoach *)coach shareType:(ShareType)shareType;

+ (void)shareUserLinkWithType:(ShareType)shareType;

+ (void)talkToSupportThroughQQ;

@end
