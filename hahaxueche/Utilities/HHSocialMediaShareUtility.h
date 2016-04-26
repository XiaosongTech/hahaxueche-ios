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
    ShareTypeWeibo,
    ShareTypeWeChat,
    ShareTypeWeChatTimeLine,
};

typedef void (^MessageCompletion) (OSMessage *message);

@interface HHSocialMediaShareUtility : NSObject

+ (instancetype)sharedInstance;


- (void)shareCoach:(HHCoach *)coach shareType:(ShareType)shareType;

- (void)shareUserLinkWithType:(ShareType)shareType;

- (void)talkToSupportThroughQQ;

- (void)generateUserReferLinkWithCompletion:(MessageCompletion)completion;

@property (nonatomic, strong) OSMessage *userReferMessage;


@end
