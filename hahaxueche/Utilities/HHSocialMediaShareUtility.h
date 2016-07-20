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
typedef void (^LinkCompletion) (NSString *link);

@interface HHSocialMediaShareUtility : NSObject

+ (instancetype)sharedInstance;


- (void)shareCoach:(HHCoach *)coach shareType:(ShareType)shareType;

- (void)shareUserLinkWithType:(ShareType)shareType;


- (void)getUserReferLinkWithCompletion:(LinkCompletion)completion;

@property (nonatomic, strong) NSString *userReferBranchLink;


@end
